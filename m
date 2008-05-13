Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYEMSGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYEMSGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbYEMSGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:06:01 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:55128 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYEMSGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:06:00 -0400
Message-ID: <001e01c8b523$fd89d2d0$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Kernel hangs in SMP + VMware environment.
Date: Tue, 13 May 2008 20:05:08 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX194LXEa8RhucP3Rnr24R48MmBQbaiVt5WId+HIu
	Fr6dyr8WpOM6EiEMaTcePwIDo4iB12wQP9LzaAHKnlPNp5g7lV
	YMYnBPiOs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe related to http://bugzilla.kernel.org/show_bug.cgi?id=9834  ?

you say "recent" , so this does happen from 2.6.21 to 2.6.26rc2 ?
does that happen only on a dedicated vmware box, or on different ones?
vmware-tools active? ->stop -> different ?

could you provide some more information about your hardware/vmware 
environment ?
does that happen on esx or on hosted products (workstation, server, 
player..) ?

regards
roland




List:       linux-kernel
Subject:    Kernel hangs in SMP + VMware environment.
From:       Tetsuo Handa <penguin-kernel () I-love ! SAKURA ! ne ! jp>
Date:       2008-05-12 21:41:34
Message-ID: 200805130641.CDG56299.QStFOLVOOJFHMF () I-love ! SAKURA ! ne ! 
jp
[Download message RAW]

I'm experiencing hang up problem with recent kernels in VMware environment.

Here are two examples.

http://I-love.SAKURA.ne.jp/tmp/messages.1 (203kB)
http://I-love.SAKURA.ne.jp/tmp/messages.2 (1.7MB)

The messages.1 is a log when "tar" stopped processing
while extracting a .tar.bz2 file by
"rpmbuild -bb --target i586 --with baseonly kernel.spec".
I got this log in runlevel 3 of Fedora 8.

The messages.2 is a log when the compiler processes (e.g. "cc1")
seem to be hanged up (no compiler messages appear for minutes,
which unlikely happen).
I got this log in runlevel 1 of Fedora 8
by "rpmbuild -bb --target i586 --with baseonly kernel.spec"
after starting rsyslog and stopping anacron.

I experience this problem in many distro (e.g. Fedora, Ubuntu, SuSE),
which use kenel (I think) around 2.6.21 and later.

I experience this problem only in VMware.
I have never experienced this problem in native environment.

I experience this problem only when I assign 2 CPUs to VMware.
I have never experienced this problem with 1 CPU.

May be something scheduler related in SMP + VMware environment.

The a.out process in the log files are http://lkml.org/lkml/2008/5/12/130
What other information should I dump for identifying the location of hang 
up?

Regards.

