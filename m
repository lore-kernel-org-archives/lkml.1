Return-Path: <linux-kernel-owner+w=401wt.eu-S1763358AbYCCVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763358AbYCCVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763388AbYCCVXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:23:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:46487 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763264AbYCCVXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:23:24 -0500
In-Reply-To: <962471e5d2b8c88858dd5e0f50269751@kernel.crashing.org>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <962471e5d2b8c88858dd5e0f50269751@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <4ffd9be7b13d6300b888c146d6d040d5@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: hans.rosenfeld@amd.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Date: Mon, 3 Mar 2008 22:22:23 +0100
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> so (on 32-bit) ~_PAGE_PSE is ~0x80L is 0xffffff7f, which when cast to
> 64-bit is 0x00000000ffffff7f,

Actually, it is signed, so this isn't true.  Comments about unsafeness
still apply.


Segher

