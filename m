Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZION0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZION0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZION0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:26:01 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:37233 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZION0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:26:00 -0400
X-SpamScore: -17
X-BigFish: VPS-17(z78cM2005nz1432R98dN148cMzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ0LB5-01-H4R-02
X-M-MSG: 
Date: Tue, 15 Sep 2009 15:25:49 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86 <x86@kernel.org>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] Fix:
 amd64_edac.c:(.text+0x3e9491): undefined reference to `amd_decode_nb_mce'
Message-ID: <20090915132549.GA3824@aftab>
References: <20090914171905.GD13615@aftab>
 <20090915115935.GA24391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090915115935.GA24391@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Sep 2009 13:25:53.0391 (UTC) FILETIME=[0CAEEFF0:01CA3608]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 01:59:35PM +0200, Ingo Molnar wrote:
> 
> -tip testing found the following build failure (config attached):
> 
> drivers/built-in.o: In function `amd64_check':
> amd64_edac.c:(.text+0x3e9491): undefined reference to `amd_decode_nb_mce'
> drivers/built-in.o: In function `amd64_init_2nd_stage':
> amd64_edac.c:(.text+0x3e9b46): undefined reference to `amd_report_gart_errors'
> amd64_edac.c:(.text+0x3e9b55): undefined reference to `amd_register_ecc_decoder'
> drivers/built-in.o: In function `amd64_nbea_store':
> amd64_edac_dbg.c:(.text+0x3ea22e): undefined reference to `amd_decode_nb_mce'
> drivers/built-in.o: In function `amd64_remove_one_instance':
> amd64_edac.c:(.devexit.text+0x3eea): undefined reference to `amd_report_gart_errors'
> amd64_edac.c:(.devexit.text+0x3ef6): undefined reference to `amd_unregister_ecc_decoder'
> 
> the AMD EDAC code has a dependency on CONFIG_CPU_SUP_AMD facilities. The 
> patch below solves the problem here.

Dang(!), thanks for catching that one. Will add it to the lineup of the
next pull request to Linus.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

