Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbXCTHGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbXCTHGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXCTHGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:06:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:64409 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXCTHGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NXGhbnUtBBysUM1yeU3/I3jRcr15NoG+/cgytmHIhvdSguLvaI1tbgopJ95BNNqD7Queg118mGoWjIx4VYiTl9Zr/QcjLJatHrN36NtfHwK0oubecoIAWhHvcCeWmRzjjvc3Lr/VxITCKH98oReNKF3lBGea4FY/OY4CHiR6NLs=
Message-ID: <84144f020703200006q5fbd7835y216426e77e48cc71@mail.gmail.com>
Date: Tue, 20 Mar 2007 09:06:41 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Cc: mpm@selenic.com, "Christoph Lameter" <clameter@sgi.com>,
       "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070319144100.8a87f288.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319141038.212d4ac9.akpm@linux-foundation.org>
	 <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi>
	 <20070319144100.8a87f288.akpm@linux-foundation.org>
X-Google-Sender-Auth: 9f7f0e6748f1f070
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> The BUG_ON (at least) should probably be moved into CONFIG_DEBUG_SLAB.

No it shouldn't. Letting non-slab pages pass through causes nasty and
hard to debug problems which is why we have the BUG_ONs in the first
place:

http://lkml.org/lkml/2006/5/8/101

                                           Pekka
