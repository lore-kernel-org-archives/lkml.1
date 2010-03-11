Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0CKKeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:34:07 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:52203 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0CKKd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:33:59 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNzz1202hzzz32i2a8h87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZ45CD-01-108-02
X-M-MSG: 
Date: Thu, 11 Mar 2010 11:33:45 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] KVM: MMU: Make tdp_enabled a mmu-context
 parameter
Message-ID: <20100311103345.GQ5619@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <1267643541-451-3-git-send-email-joerg.roedel@amd.com>
 <4B94C0B5.7080507@redhat.com>
 <20100310144426.GK5619@amd.com>
 <4B97B269.3010502@redhat.com>
 <20100310152643.GO5619@amd.com>
 <4B9891F9.6080706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B9891F9.6080706@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Mar 2010 10:33:46.0343 (UTC) FILETIME=[54663770:01CAC106]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 08:47:21AM +0200, Avi Kivity wrote:
> 
> tdp is still used in both cases, so that name is confusing.  We
> could call it mmu.direct_map (and set it for real mode?) or
> mmu.virtual_map (with the opposite sense).  Or something.

I like the mmu.direct_map name. Its a good term too, I will change it in
the patch.

	Joerg


