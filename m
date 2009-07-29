Return-Path: <linux-kernel-owner+w=401wt.eu-S932141AbZG2N7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbZG2N7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZG2N7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:59:18 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:7632 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755200AbZG2N7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:59:16 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432R98dN936eM9371Pzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNJQUF-04-6EE-01
Date: Wed, 29 Jul 2009 15:58:59 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] Nested SVM cleanups
Message-ID: <20090729135859.GN18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <4A70492E.2080705@redhat.com>
 <20090729130944.GE18313@amd.com>
 <4A704F5B.9000800@redhat.com>
 <20090729133840.GG18313@amd.com>
 <4A705327.8050101@redhat.com>
 <20090729134857.GL18313@amd.com>
 <4A7055D4.7000905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A7055D4.7000905@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:58:59.0669 (UTC) FILETIME=[B8C4E850:01CA1054]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:59:48PM +0300, Avi Kivity wrote:
> On 07/29/2009 04:48 PM, Joerg Roedel wrote:
> >Performance isn't too bad even without this. At least if the host
> >supports nested paging :) But shadow nested paging should give nested
> >svm a real boost, thats very true.
> 
> Well, any workload that benefits from npt would benefit from nnpt a
> lot more.

Most complicated part will be the two dimensional software page walker.
That will be a somewhat intrusive change (at least if I do it without
code duplication). But lets see how challenging this will become...

	Joerg


