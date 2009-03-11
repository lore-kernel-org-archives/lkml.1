Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZCKAVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZCKAVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZCKAU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:20:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZCKAU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:20:58 -0400
Message-ID: <49B703D4.1000008@zytor.com>
Date: Tue, 10 Mar 2009 17:20:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: the arch/x86 maintainers <x86@kernel.org>
Subject: x86: removing zImage support?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm thinking again about removing zImage support.  An "allnoconfig"
kernel (with CONFIG_EMBEDDED=y to expose additional knobs, and
CONFIG_BINFMT_ELF=y so it can do anything at all) is currently 487K on
i386 -- very close to the upper limit of 512K for zImage.

Are there *any* residual users of this, or should I just push a patch to
remove it once and for all?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

