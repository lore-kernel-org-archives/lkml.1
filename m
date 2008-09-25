Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYIYEqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYIYEqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYIYEqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:46:21 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46214 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbYIYEqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:46:21 -0400
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>
In-Reply-To: <48DB15DB.8040501@zytor.com>
References: <20080221115452.GB13948@elte.hu>
	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>
	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
	 <48DB15DB.8040501@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 24 Sep 2008 21:46:18 -0700
Message-Id: <1222317978.23524.117.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 21:38 -0700, H. Peter Anvin wrote:
> Alok kataria wrote:
> >
> > Even if there is anything on that port on native hardware it would
> > work perfectly well and is _safe_.
> > First let me post the code to access this backdoor port (the way it
> > should really be done )
> >
> > So whenever we query port  0x5658 , with the GETVERSION command (which
> > is the first thing we do with this port), we expect that  eax !=
> > 0xFFFFFFFF   and ebx has a  VMWARE specific MAGIC value.  Please note
> > that ebx has been initialized to zero in the code above.
> >
> 
> You have no idea what you just did to a real piece of hardware.
Why ? what do you mean ? 
ebx is a local variable in the code above that i posted. 
Only when on hypervisor will we write the magic value over there.
How can this affect native hardware, i fail to understand. 
Please explain.

Thanks,
Alok
> 
>         -hpa

