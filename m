Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYJVRzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYJVRzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYJVRy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:54:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:43890 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYJVRyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QFJ1fELevJj6pwKWnrhyjpTRE6UnKeDk5R9GcjQOtizuJoG73h6klv4dW8YdIbi/eE
         yrV4LzYRHwNj3SqEXAx0TRr5EnJxOxAjGNSU2KcxWLd8fdvwBCsMEnCfaiZusZlMjp6q
         I9OEXqs3OBRNlJjYak0DrP/5yJOiEkGzcGClk=
Date: Wed, 22 Oct 2008 21:54:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022175449.GK9639@localhost>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221037320.7633@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Wed, Oct 22, 2008 at 10:47:09AM -0700]
> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>
>> Christoph how about this one?
>
> Ok. Looks a bit better but we still have two maxes here
>
> s->max which refers to the maximum number of objects per slab page for a 
> specific slab cache (depends on the runtime configuration). OO_MAX_OBJS  
> refers to the maximum number of objects per slab page that any slab cache 
> can be configured for which is a compile time limit.
>
> Maybe this is okay, Pekka?
>

If name is not that good -- maybe OO_OBJS_PER_PAGE? :)

		- Cyrill -
