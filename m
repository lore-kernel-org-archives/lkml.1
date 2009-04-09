Return-Path: <linux-kernel-owner+w=401wt.eu-S936737AbZDIUtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936737AbZDIUtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbZDIUtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:49:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:42458 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759732AbZDIUtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:49:10 -0400
In-Reply-To: <20090409125237.GD7921@lug-owl.de>
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090408173332.GB20187@ldl.fc.hp.com> <20090409125237.GD7921@lug-owl.de>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1D6A3AE1-14BE-491F-89F2-BC9CE04F444E@kernel.crashing.org>
Cc: Alex Chiang <achiang@hp.com>, Andrew Morton <akpm@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: cross-compilers
Date: Thu, 9 Apr 2009 22:51:38 +0200
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is anybody building GCC trunk for the targets on a daily basis?

Not daily yet, but often anyway.  Also binutils and kernel mainline.

Scripts: <http://git.infradead.org/users/segher/buildall.git>

Edit "config" for your local paths etc.
Run  ./build [--kernel] <arch> [<some-defconfig>]  to build a toolchain
and a kernel, or only the kernel if --kernel is given.  Run  ./buildall
to build a toolchain+kernel for all archs.


Segher

