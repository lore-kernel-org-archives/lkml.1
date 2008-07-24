Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYGXKud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYGXKud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYGXKu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:50:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYGXKuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:50:25 -0400
Date: Thu, 24 Jul 2008 12:50:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Olaf Hering <olaf@aepfle.de>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: asm-x86/processor-flags.h, CONFIG_* leaks
Message-ID: <20080724105014.GK28817@elte.hu>
References: <20080721124656.GA28618@aepfle.de> <20080721130635.GA19123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721130635.GA19123@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Mon, Jul 21, 2008 at 2:46 PM, Olaf Hering <olaf@aepfle.de> wrote:
> >
> > asm-x86/processor-flags.h is an exported header,
> > via 'make headers_install_all'
> >
> > Please move X86_VM_MASK inside __KERNEL__
> 
> Oops, this seems to be my fault. Find the fix below.

applied to tip/x86/urgent, thanks Vegard and Olaf.

	Ingo
