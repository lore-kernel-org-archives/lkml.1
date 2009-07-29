Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZG2NKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZG2NKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZG2NKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:10:11 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:30594 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754673AbZG2NKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:10:09 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM1442J9371Pzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNJOK8-03-6FF-01
Date: Wed, 29 Jul 2009 15:09:44 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] Nested SVM cleanups
Message-ID: <20090729130944.GE18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <4A70492E.2080705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A70492E.2080705@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:09:44.0401 (UTC) FILETIME=[D74ACC10:01CA104D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:05:50PM +0300, Avi Kivity wrote:
> On 07/29/2009 03:56 PM, Joerg Roedel wrote:
> >Hi,
> >
> >here is a first round of patches to clean up the code for SVM virtualization
> >for KVM on AMD. There is more to clean up but since I am on vacation the rest
> >of the week here is what I have queued up so far. Maybe this saves me from
> >rebasing this code next week ;-)
> >I tested these patches with KVM in KVM and it works stable with and without
> >nested SMP. It doesn't seem to break anything.
> >
> 
> I seem to recall nested smp used to be broken.  Am I mistaken, or do
> these patches fix rather than clean up?

Nested SMP was broken in one of the early version of the nested SVM
code. In the current upstream version it works quite well.

> 
> >       kvm/svm: make nested svm debugging runtime configurable
> 
> Should be migrated to tracepoints.

Ok, I tried to align debugging to the mmu debugging code. But
tracepoints are better of course.

	Joerg


