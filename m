Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032Ab0AVRko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0AVRko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027Ab0AVRkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:40:40 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51586 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab0AVRki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:40:38 -0500
Date: Fri, 22 Jan 2010 18:40:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, mingo@elte.hu, tglx@linutronix.de,
       andreas.herrmann3@amd.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable
 fixes
Message-ID: <20100122174049.GC19425@aftab>
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
 <4B59DF4C.7040608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B59DF4C.7040608@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 09:24:28AM -0800, H. Peter Anvin wrote:
> On 01/22/2010 07:01 AM, Borislav Petkov wrote:
> > these are a bunch of fixes which correct the disabling of L3 cache
> > indexes. This is needed, for example, in the case when excessive
> > correctable L3 error rates are observed. In a later step, this
> > functionality will be connected to the mcheck mechanism and used to
> > evaluate occurring L3 tag and data array errors and then disable the
> > respective failing L3 cache regions in order to defer system failure
> > before a sysop can intervene.
> > 
> > Those patches are also good -stable candidates.
> 
> Hmmm... I'm not sure I see a strong justification for a late -rc push
> into Linus/stable push for for these... I think you would have to
> explicitly make the case if you want them to be considered as such.

Well, on the one hand, they fix real bugs in the L3 cache index disable
code and since they're bugfixes, they are eligible late -rc candidates.

On the other hand, however and more importantly, the machines which
have that feature are not selling yet so postponing the patches for the
next merge window is still ok. I'll backport them then to .32 for the
distro kernels and .33 and I think we are going to be fine this way.

So queueing them for .34 is still fine with me, thanks.

-- 
Regards/Gruss,
ボリス.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
