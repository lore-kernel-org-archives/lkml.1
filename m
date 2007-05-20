Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbXETOAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbXETOAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbXETOAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:00:12 -0400
Received: from www.osadl.org ([213.239.205.134]:35111 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755955AbXETOAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:00:11 -0400
Subject: Re: [realtime kernel 2.6.21-rt2 and up] Extremely slow bootup for
	x86_64
From: Thomas Gleixner <tglx@linutronix.de>
To: Maarten Maathuis <madman2003@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6d4bc9fc0705200525m1b72aaaevf8a1d090038bb7dc@mail.gmail.com>
References: <6d4bc9fc0705200525m1b72aaaevf8a1d090038bb7dc@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 20 May 2007 16:06:22 +0200
Message-Id: <1179669982.21827.25.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 14:25 +0200, Maarten Maathuis wrote:
> When i try to boot a kernel higher than 2.6.21-rt1, it boots very
> slowly. It takes minutes to even detect two cdrom players. I noticed
> in the changelog:
> 
> - x86/64 high-res timers and dynticks update (Thomas Gleixner)
> 
> I included the .config from 2.6.21-rt1, which i ran make oldconfig on.
> 
> I cannot provide any other information, since i estimate it will take
> ages to bootup.

Does the same problem show up with

http://tglx.de/projects/hrtimers/2.6.22-rc2/linux-2.6.22-rc2-x86_64-highres-v1.patch

	tglx



