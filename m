Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZG2NsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZG2NsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZG2NsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:48:05 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:5789 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755481AbZG2NsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:48:03 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432R98dN936eM9371Pzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNJQBH-03-7VT-01
Date: Wed, 29 Jul 2009 15:47:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kvm/svm: cache nested intercepts
Message-ID: <20090729134738.GK18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <1248872192-30881-9-git-send-email-joerg.roedel@amd.com>
 <4A704AFF.8070702@redhat.com>
 <20090729131319.GF18313@amd.com>
 <4A704DEA.8040101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A704DEA.8040101@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:47:38.0418 (UTC) FILETIME=[22B64120:01CA1053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:26:02PM +0300, Avi Kivity wrote:
> On 07/29/2009 04:13 PM, Joerg Roedel wrote:
> >On Wed, Jul 29, 2009 at 04:13:35PM +0300, Avi Kivity wrote:
> >>I don't see the benefit of this patch.  Accessing the cache is just
> >>as expensive as accessing the real vmcb.
> >
> >The benefit is that we don't have to gup and map the nested vmcb just
> >for checking who will take the intercept.
> 
> Makes sense.
> 
> >Another reason is that with
> >this patch the behavior of nested SVM is more aligned to real hardware.
> 
> Even more important, please put this in the commit log.

Ok, will do.


