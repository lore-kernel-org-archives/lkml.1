Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXF1ETj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXF1ETj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 00:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXF1ETb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 00:19:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXF1ETa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 00:19:30 -0400
Message-ID: <46833311.4000209@zytor.com>
Date: Thu, 28 Jun 2007 00:03:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Adrian Bunk <bunk@stusta.de>, LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Subject: Re: Userspace compiler support of "long long"
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
In-Reply-To: <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
>> 
> The only trick is if you care about building 32-bit compat code using 
> 64-bit linux kernel headers.  In that case we should probably just make 
> all archs use "long long" for their 64-bit integers, unless there's some 
> platform I'm not remembering where "long long" is 128-bits or bigger.  
> The other benefit is that people could then just use the printf format 
> "%llu" for 64-bit integers instead of having to conditionalize it all 
> over the place.
> 

No, you really don't want to do that, because then u64 != uint64_t on 
those platforms.

	-hpa

