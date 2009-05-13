Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZEMHTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZEMHTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 03:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZEMHTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 03:19:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:60560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbZEMHTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 03:19:36 -0400
Subject: Re: [PATCH 8/10 -tip] x86: Add cpufeature for Microcode update
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <20090513054627.GB9991@alberich.amd.com>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam>
	 <1242142849.2547.19.camel@ht.satnam> <1242142908.2547.20.camel@ht.satnam>
	 <1242142941.2547.21.camel@ht.satnam> <1242142996.2547.22.camel@ht.satnam>
	 <20090513054627.GB9991@alberich.amd.com>
Content-Type: text/plain
Date: Wed, 13 May 2009 12:48:34 +0530
Message-Id: <1242199114.4218.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 07:46 +0200, Andreas Herrmann wrote:
> On Tue, May 12, 2009 at 09:13:16PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > Setting microcode update feature to friendly access of UCODE MSRs like:
> > 1. IA32_PLATFORM_ID (Intel)
> > 2. IA32_UCODE_WRITE (Intel)
> > 3. IA32_UCODE_REV (Intel)
> > 4. MSR_AMD64_PATCH_LEVEL (AMD)
> > 5. MSR_AMD64_PATCH_LOADER (AMD)
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> NAK! There is absolutely no point in moving the CPU
> family/model/revision checks from the microcode drivers into generic
> setup code.

Thanks, trashed.

--
JSR

