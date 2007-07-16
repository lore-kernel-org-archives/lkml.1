Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbXGPHWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbXGPHWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXGPHWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:22:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:49003 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbXGPHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NPbQ9X7yImf52ge79QvkK/mLQFyuElDDqqFqYaMgAEzY+9G3qodQC/tSuH9FmJMLcPswKZIkaV1C1yKr4bdzCFc6tUHu5iA3+HCo5HX8BrPKMLIYJFnOluxFBaSb60l9Y3VAzwq0sxdLXbKH0Xvt8GZIYn5/9omGQ3mcrS5qEKk=
Message-ID: <84144f020707160022p37a2d712g21c3d5c89ed6345d@mail.gmail.com>
Date: Mon, 16 Jul 2007 10:22:29 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] slob: reduce list scanning
Cc: "Matt Mackall" <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <469B09AB.5010309@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070714055434.GQ11115@waste.org> <469B09AB.5010309@yahoo.com.au>
X-Google-Sender-Auth: 89e18d3e1050de26
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Actually SLOB potentially has some fundamental CPU cache hotness
> advantages over the other allocators, for the same reasons as
> its space advantages.

Because consecutive allocations hit the same cache-hot page regardless
of requested size where as SLUB by definition distributes allocations
to different pages (some of which may not be hot)?
