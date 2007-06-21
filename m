Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXFUOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXFUOlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbXFUOkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:40:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33922 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbXFUOkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:40:53 -0400
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <467A8C9E.4030703@s5r6.in-berlin.de>
References: <467543FA.60905@googlemail.com>
	 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
	 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
	 <1182381667.2701.7.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.98.0706201649060.3593@woody.linux-foundation.org>
	 <1182403401.2863.10.camel@laptopd505.fenrus.org>
	 <467A8C9E.4030703@s5r6.in-berlin.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 21 Jun 2007 07:36:46 -0700
Message-Id: <1182436606.2863.12.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Shouldn't we add something to the help texts?
> 
> +	This option also marks kernel text pages as write-protected,
> +	except if you enable KPROBES.
> 
> CMIIW.
> 
> As mentioned elsewhere in this thread, replacing CONFIG_DEBUG_RODATA by
> CONFIG_WRITEPROTECT_RODATA and CONFIG_WRITEPROTECT_TEXT might be a
> better idea.  The latter should be mutual exclusive with CONFIG_KPROBES.


lets do the minimal now for 2.6.22, and do it right for .23 please

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

