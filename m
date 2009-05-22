Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZEVUfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZEVUfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbZEVUfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:35:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:14423 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108AbZEVUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=frnxpf0ulaw7UCq3vysDzzJjYIpM/ZbKczF1loVlEr8q+jijTr6fDtqkmfSh+UjElN
         1kZEqtAJOkcuQCUs3EQlvfehOOyyKrF2lDjIveOV5Iyx0jasSdbL5fZR6bSiakNbjHxq
         QA4/vYrDIlHdFx2WH+1InQNeoGlnJes26uNt0=
Date: Sat, 23 May 2009 00:35:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on
	and on.
Message-ID: <20090522203529.GI5354@lenovo>
References: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com> <20090522200239.GD5354@lenovo> <4A170713.402@zytor.com> <20090522202154.GG5354@lenovo> <4A1709D9.4070300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1709D9.4070300@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Fri, May 22, 2009 at 01:23:53PM -0700]
| Cyrill Gorcunov wrote:
| > 
| > It was about a half year ago (need googling to be precise :)
| > but I was reported about Xeon processor which identify itself
| > as having "external" apic. So I hardly believe if real external
| > device with ICC bus were used.
| >  
| 
| Details, please.  It might even be a bug in the test.
| 
| 	-hpa
| 

Here is it

	http://lkml.org/lkml/2008/10/17/147
	http://lkml.org/lkml/2008/10/20/144

and commit db96b0a in mainline

	-- Cyrill
