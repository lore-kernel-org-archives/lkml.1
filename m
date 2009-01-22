Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZAVWla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZAVWla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZAVWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:41:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZAVWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:41:19 -0500
Message-ID: <4978F5F8.1040103@zytor.com>
Date: Thu, 22 Jan 2009 14:40:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Avuton Olrich <avuton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due
 to dc1e35c
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com> <20090119215736.GE31356@linux-os.sc.intel.com> <4974F9A8.7060107@zytor.com> <87bpu1dyl6.fsf@basil.nowhere.org> <20090122222250.GI28352@linux-os.sc.intel.com>
In-Reply-To: <20090122222250.GI28352@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> Ok. Here is the patch for this aswell. Thanks.

I wonder if it wouldn't be better to do this in the CPUID code rather 
than in the xsave code...

	-hpa
