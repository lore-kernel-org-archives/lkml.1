Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbYFZTWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbYFZTWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYFZTWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:22:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYFZTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:22:32 -0400
Message-ID: <4863EB73.8070404@kernel.org>
Date: Thu, 26 Jun 2008 12:18:11 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Bernhard Walle <bwalle@suse.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
References: <1214423826-12628-1-git-send-email-bwalle@suse.de> <1214423826-12628-2-git-send-email-bwalle@suse.de> <20080625224301.GE32344@redhat.com> <18531.20387.111875.576837@harpo.it.uu.se> <20080626104524.2d7ed1ab@halley.suse.de> <18531.23894.572847.322265@harpo.it.uu.se> <4863D930.2040300@kernel.org> <20080626181841.GE3878@redhat.com>
In-Reply-To: <20080626181841.GE3878@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
>>>
>> Making this depend on KEXEC would be most unfortunate.  This is valuable  
>> information for finding all kinds of issues even in the absence of KEXEC.
>>
> 
> Agreed.
> 
>> I really don't see a point in making this configurable, except perhaps  
>> under CONFIG_EMBEDDED.
> 
> I think we should just not put this functionality under any CONFIG option.
> If we put it under CONFIG_EMBEDDED,  then even for using kexec, one
> shall have to turn CONFIG_EMBEDDED on which probably does not make much
> sense.
> 

Well, it should be *enabled* for !EMBEDDED.

	-hpa
