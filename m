Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab0CANd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:33:58 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:39658 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0CANd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:33:57 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zba6lz1432R98dN936eM9371Pzz1202hzzz32i6bh2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLV09-02-FAX-02
X-M-MSG: 
Date: Mon, 1 Mar 2010 14:33:46 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: SVM: Use svm_msrpm_offset in
 nested_svm_exit_handled_msr
Message-ID: <20100301133346.GD31544@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
 <1267118149-15737-4-git-send-email-joerg.roedel@amd.com>
 <4B87A2D0.2040605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B87A2D0.2040605@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Mar 2010 13:33:46.0759 (UTC) FILETIME=[D1D16970:01CAB943]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 12:30:40PM +0200, Avi Kivity wrote:
> On 02/25/2010 07:15 PM, Joerg Roedel wrote:
> >There is a generic function now to calculate msrpm offsets.
> >Use that function in nested_svm_exit_handled_msr() remove
> >the duplicate logic.
> >
> 
> Hm, if the function would also calculate the mask, then it would be
> useful for set_msr_interception() as well.

The set_msr_interception is the only caller which need this mask. I
prefer to let this calculation there. The msrpm merge function only
needs the offset.

	Joerg


