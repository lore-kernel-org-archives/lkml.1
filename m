Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZG3AvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZG3AvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZG3AvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:51:05 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:56206 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbZG3AvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:51:05 -0400
Message-ID: <4A70EC76.6060109@ct.jp.nec.com>
Date: Thu, 30 Jul 2009 09:42:30 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/1] task_struct cleanup: move binfmt field to mm_struct
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com> <20090724161449.GA3509@redhat.com> <4A6CF466.9040608@ct.jp.nec.com> <20090727165901.GA8854@redhat.com> <4A6E98DC.5020200@ct.jp.nec.com> <20090728143734.GA6664@redhat.com>
In-Reply-To: <20090728143734.GA6664@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is task_struct cleanup patch.

This update patch replaces the below patches;
- task_struct-cleanup-move-binfmt-field-to-signal_struct.patch
- task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct.patch
they have been already dropped from -mm.

This patch can be applied Oleg's patch;
- exec-fix-set_binfmt-vs-sys_delete_module-race.patch

thanks,
Hiroshi
