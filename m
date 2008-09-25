Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYIYKXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYIYKXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYIYKXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:23:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:32102 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYIYKXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W8d3hr9e+3ZpwHTuj0jIXVoW/vpME9wgQB+nRPdtVmsitKPIQxXSTYbjhMC/oGBlz1
         Vu9v47Yk5UQGjDH6QYs2nd3TKuTI3RX+IL5+01uSKh4kALpdNyICrZaXikaMBcU14DqA
         jGpEdy2GD8pxOgyYSbytVzFv9DFnrTu34qduo=
Date: Thu, 25 Sep 2008 18:23:04 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: David Sanders <linux@sandersweb.net>
Cc: linux-kernel@vger.kernel.org, Yan Li <elliot.li.tech@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925102304.GA15948@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48DA6887.1060709@zytor.com> <20080925003220.GE21049@yantp.cn.ibm.com> <200809250556.49887.linux@sandersweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809250556.49887.linux@sandersweb.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 05:56:48AM -0400, David Sanders wrote:
> On Wednesday 24 September 2008 20:32, Yan Li wrote:
> > If you can tell me what manufacture vendor string is in Virtual PC I
> > can make another similar patch using dmi_name_in_vendors().
> From: i8042-x86ia64io.h
> 
> 	{
> 		.ident = "Microsoft Virtual Machine",
> 		.matches = {
> 			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> 			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
> 			DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
> 		},
> 	},

Oh, cool, thanks!

-- 
Li, Yan
