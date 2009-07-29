Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZG2Nrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZG2Nrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZG2Nra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:47:30 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35275 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZG2Nr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:47:29 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z34a4jz1432R98dNzz1202hzzz32i6bh203h43j)
X-WSS-ID: 0KNJQAP-04-60P-01
Date: Wed, 29 Jul 2009 15:47:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] kvm/svm: copy only necessary parts of the
 control area on vmrun/vmexit
Message-ID: <20090729134714.GJ18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <1248872192-30881-6-git-send-email-joerg.roedel@amd.com>
 <4A704ED9.2000604@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A704ED9.2000604@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:47:14.0325 (UTC) FILETIME=[1459F450:01CA1053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 03:30:01PM +0200, Alexander Graf wrote:
> Joerg Roedel wrote:
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >   
> 
> What's the reason behind this?
> 
> Acked-by: Alexander Graf <agraf@suse.de>

Reason is to not copy the reserved fields of the control area. These
fields sum up to size of 899 bytes which are unnecessarily copied.

	Joerg


