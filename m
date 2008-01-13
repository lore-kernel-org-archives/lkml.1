Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbYAMIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbYAMIVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 03:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYAMIVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 03:21:30 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:58516 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751127AbYAMIV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 03:21:29 -0500
Message-ID: <400212488.11031@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 13 Jan 2008 16:21:06 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Joerg Platte <jplatte@naasa.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801130032.32495.jplatte@naasa.net> <400206690.16519@ustc.edu.cn> <200801130905.44855.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801130905.44855.jplatte@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JDy5a-0001al-Tk@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 09:05:43AM +0100, Joerg Platte wrote:
> Am Sonntag, 13. Januar 2008 schrieb Fengguang Wu:
> 
> > No idea yet :-/ I'm afraid I have to trouble you again - the bug just
> > refused to appear in my system. I prepared a kernel module for you to
> > gather more information:
> 
> > make && insmod ext2-writeback-debug.ko && sleep 1s && rmmod
> > ext2-writeback-debug dmesg > ext2-writeback-debug.dmesg
> 
> Unfortunately, I unable to compile the module:
 
> make -C /lib/modules/2.6.24-rc7-ext2/build SUBDIRS=/export/src modules
> make[1]: Entering directory `/export/src/linux-2.6.24-rc7'
>   CC [M]  /export/src/ext2-writeback-debug.o
> /export/src/ext2-writeback-debug.c:89: error: variable ‘my_kprobe’ has 
> initializer but incomplete type

Do you have CONFIG_KPROBES=y?

