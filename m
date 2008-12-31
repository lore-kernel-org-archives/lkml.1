Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYLaJRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYLaJRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYLaJRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:17:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57342 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYLaJRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:17:09 -0500
Message-ID: <495B3857.90802@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 17:16:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [-tip tree] compile error in arch/ia64/kernel/acpi.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/ia64/kernel/acpi.c:205: error: conflicting types for 'total_cpus'
include/linux/smp.h:25: error: previous declaration of 'total_cpus' was here

due to [PATCH 3/3] cpumask: add sysfs displays for configured and disabled cpu maps
(http://lkml.org/lkml/2008/12/19/25)
