Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbXIHHEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbXIHHEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXIHHEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:04:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:45962 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbXIHHEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=g8EgkjzlbMFCLv7j5ayc0fMpcVSc0LHaJcB9x0E3Al0wvi5gsDH9Aik5as4gD3+dyAX/koYaQUfKExItyaEA+SCiQlss8vbvWfjcvlkIS0mcbZyBwasr4z+u3QsAwc5oPniCrgXOWPd5pmgtZ70+wB6TW2zNt2VwV1o4G3MJVP0=
Date: Sat, 8 Sep 2007 11:04:38 +0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] Linux Kernel Markers - Port SPU to markers
Message-ID: <20070908070438.GA1819@martell.zuzino.mipt.ru>
References: <20070906200733.194442762@polymtl.ca> <20070906200827.452767571@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200827.452767571@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:07:39PM -0400, Mathieu Desnoyers wrote:
> Andrew, any chance to get this into -mm ASAP so we can have it in
> 2.6.24?
> 
> Just in case anyone wonders what this is usefulfor I've ported my
> hacking spu tracing code to it, and if markers get in I'd push a cleaned
> up version of this in the tree of the benefit of everyone trying to
> follow what's going on in the spufs code.  Similarly I'd like to port
> the xfs tracing code over to it which is very helpful in trying to
> debug filesystem issues.
> 
> Note that in this patch the actual logging code is rather nasty
> hand-crafted code lifted from the tcp probe in tree which would benefit
> of going away in favour of more general tracing code aswell.
> 
> Changelog:
> - Porting to 2.6.23-rc4-mm1 gave a reject (a trace point location disappeared)
>   from spufs_ps_nopfn() : spufs_ps_nopfn__sleep and spufs_ps_nopfn__wake.
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Where are Christoph's attributions?
