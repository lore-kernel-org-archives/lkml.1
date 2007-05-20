Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbXETNJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbXETNJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXETNJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:09:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:38614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbXETNJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:09:24 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christian Volkmann <haveaniceday@cv-sv.de>
Subject: Re: Via C3: other flags possible ?
Date: Sun, 20 May 2007 14:59:46 +0200
User-Agent: KMail/1.9.6
Cc: Claas Langbehn <claas@rootdir.de>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <464F5C8F.5000304@cv-sv.de> <464F7C09.8060809@cv-sv.de>
In-Reply-To: <464F7C09.8060809@cv-sv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201459.46357.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> C7 Esther:
> Hmm, I expect the NX-Bit should be detected from linux during the
> boot. The NX function bit seems to be at the same place where it's
> located for other CPU.

> Unfortunately I have no C7 hardware and I am too much a beginner
> in kernel programming to prepare this "dry".
> 
> May be a "senior kernel programmer" can easy check if the C7 runs
> through the regular NX-function detection?

If it's in CPUID (nx in /proc/cpuinfo flags) it should just work.

NX also doesn't need to be handled in the early CPUID bits detection 
because the kernel can handle it not being there fine. Only bits
who when missing cause the kernel to panic early or crash need to
be tested there.

-Andi

