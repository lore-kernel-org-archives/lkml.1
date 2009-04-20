Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZDTCNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZDTCNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 22:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZDTCMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 22:12:55 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:34757 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZDTCMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 22:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iedzYVKcY+/TdgEceCfDkCMNCc5iRR6hx9qDlb1+IINmvdyEU4AjCC2kBl7gah8D9i
         KzvLBoZFhciigjXis0MPMRcdrKwlG2qrjNYcrmMOfe6bBRMVPRcD26LLZy68HbLmJZ0O
         LoBU97h06t+A400B3K22i7nKDQjPtNA1srZ0k=
Subject: "RT_PREEMPT for loongson" is updated to patch-2.6.29.1-rt8
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Nicholas Mc Guire <hofrat@hofr.at>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, zhangfx@lemote.com,
       loongson-dev@googlegroups.com, yanh@lemote.com,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Zhang Le <r0bertz@gentoo.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Mon, 20 Apr 2009 10:12:27 +0800
Message-Id: <1240193547.25532.52.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, all

I just update "RT_PREEMPT for loongson" to the latest RT_PREEMPT
(patch-2.6.29.1-rt8), welcome to pull & test it.

$ git clone git://dev.lemote.com/rt4ls.git
or
http://dev.lemote.com/http_git/rt4ls.git

this version include basic-RT support for mips, ftrace support for mips
(static function tracer/dynamic function tracer/function graph
tracer/system call tracer). 

* current status

the "system call tracer" need to fix when compiled in 64bit, because
there are several sys_call_table entries for different mips64
standards(o32, n32), currently, i only use the one in
arch/mips/kernel/scall64-o32.S via EXPORT(sys_call_table).

the "function graph tracer" is not stable under 100% load(lots of
"find /" background). 

best regards,
Wu Zhangjin

-- 
Wu Zhangjin
DSLab, Lanzhou University, China
www.lemote.com, Jiangsu Province, China

