Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbZJHQXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbZJHQXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbZJHQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:23:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56560 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727AbZJHQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:23:11 -0400
X-SpamScore: -26
X-BigFish: VPS-26(z34a4jz1432R98dN936eM9371Pzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KR7ETC-01-0CD-02
X-M-MSG: 
Date: Thu, 8 Oct 2009 18:22:22 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] KVM: SVM: Notify nested hypervisor of lost event
 injections
Message-ID: <20091008162222.GG14073@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
 <1254996199-17667-2-git-send-email-joerg.roedel@amd.com>
 <4ACE0F6C.3060103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4ACE0F6C.3060103@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Oct 2009 16:22:22.0639 (UTC) FILETIME=[83DE33F0:01CA4833]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 06:12:28PM +0200, Avi Kivity wrote:
> On 10/08/2009 12:03 PM, Joerg Roedel wrote:
> >From: Alexander Graf<agraf@suse.de>
> >
> >If event_inj is valid on a #vmexit the host CPU would write
> >the contents to exit_int_info, so the hypervisor knows that
> >the event wasn't injected.
> >
> >We don't do this in nested SVM by now which is a bug and
> >fixed by this patch.
> 
> We need to start thinking about regression tests for these bugs.  It
> would be relatively easy to set up something with save->cr3 == cr3
> (i.e. no isolation, mmu virtualization, etc.).

Should be doable with a in-kernel regression test-suite module, I think.
Triggering such (race-condition like) test cases from userspace is
somewhat hard.

	Joerg


