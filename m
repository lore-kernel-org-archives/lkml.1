Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbYGAGt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbYGAGt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYGAGtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:49:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYGAGtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:49:17 -0400
Message-ID: <4869D1F3.3030804@redhat.com>
Date: Tue, 01 Jul 2008 08:42:59 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: -Wmissing-prototypes (was: make foo() static)
References: <20080630221918.GI1536@cs181140183.pp.htv.fi>
In-Reply-To: <20080630221918.GI1536@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

> This patch makes the needlessly global kvm_smp_prepare_boot_cpu() static.

Hmm, maybe we should build the kernel with -Wmissing-prototypes?
That should make gcc print a warning for that ...

cheers,
  Gerd

-- 
http://kraxel.fedorapeople.org/xenner/
