Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0CJOrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:47:06 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:14535 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab0CJOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:47:04 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pzz1202hzzz32i6bh2a8h87h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZ2ME2-02-CLA-02
X-M-MSG: 
Date: Wed, 10 Mar 2010 15:46:46 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] KVM: X86: Add KVM_CAP_SVM_CPUID_FIXED
Message-ID: <20100310144646.GM5619@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <1267643541-451-19-git-send-email-joerg.roedel@amd.com>
 <4B94C5D3.6070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B94C5D3.6070601@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Mar 2010 14:46:46.0660 (UTC) FILETIME=[82290440:01CAC060]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 11:39:31AM +0200, Avi Kivity wrote:
> On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> >This capability shows userspace that is can trust the values
> >of cpuid[0x8000000A] that it gets from the kernel. Old
> >behavior was to just return the host cpuid values which is
> >broken because all additional svm-features need support in
> >the svm emulation code.
> >
> 
> A think we can simply fix the bug and push the fix to the various
> stable queues.

Ok, sounds good too. I have some more fixes queued up and send this one
together with them.

	Joerg


