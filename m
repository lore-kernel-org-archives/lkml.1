Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZG2NOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZG2NOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZG2NOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:14:23 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:44246 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755014AbZG2NOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:14:22 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNJORL-02-1CR-02
X-M-MSG: 
Date: Wed, 29 Jul 2009 15:13:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kvm/svm: cache nested intercepts
Message-ID: <20090729131319.GF18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <1248872192-30881-9-git-send-email-joerg.roedel@amd.com>
 <4A704AFF.8070702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A704AFF.8070702@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:13:19.0891 (UTC) FILETIME=[57BBF630:01CA104E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:13:35PM +0300, Avi Kivity wrote:
> 
> I don't see the benefit of this patch.  Accessing the cache is just
> as expensive as accessing the real vmcb.

The benefit is that we don't have to gup and map the nested vmcb just
for checking who will take the intercept. Another reason is that with
this patch the behavior of nested SVM is more aligned to real hardware.

	Joerg


