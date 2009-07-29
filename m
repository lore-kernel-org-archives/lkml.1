Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZG2NvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZG2NvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZG2NvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:51:08 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:55103 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755651AbZG2NvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:51:06 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNJQGQ-01-NG5-02
X-M-MSG: 
Date: Wed, 29 Jul 2009 15:48:57 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] Nested SVM cleanups
Message-ID: <20090729134857.GL18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <4A70492E.2080705@redhat.com>
 <20090729130944.GE18313@amd.com>
 <4A704F5B.9000800@redhat.com>
 <20090729133840.GG18313@amd.com>
 <4A705327.8050101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A705327.8050101@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:48:57.0821 (UTC) FILETIME=[520A30D0:01CA1053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:48:23PM +0300, Avi Kivity wrote:
> On 07/29/2009 04:38 PM, Joerg Roedel wrote:
> >>In that case, the next interesting target is nested npt.  This may
> >>actually make nsvm perform well.  Any plans?
> >
> >Yes. Plan is to implement this when I am through with the cleanups.
> 
> Great, this promises to be the most interesting area of development
> in kvm for those of us who don't read ppc.

Performance isn't too bad even without this. At least if the host
supports nested paging :) But shadow nested paging should give nested
svm a real boost, thats very true.

	Joerg


