Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZFZISk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZFZISk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZFZIS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:18:26 -0400
Received: from mx01.bfk.de ([193.227.124.2]:51767 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbZFZISZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:18:25 -0400
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2009 04:18:25 EDT
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       vapier@gentoo.org
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not  mounted
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
	<20090624162125.a3a9b2c4.akpm@linux-foundation.org>
	<1158166a0906241649u78c717c4q8aebfe16e6018e78@mail.gmail.com>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 26 Jun 2009 10:06:25 +0200
In-Reply-To: <1158166a0906241649u78c717c4q8aebfe16e6018e78@mail.gmail.com> (Denys Vlasenko's message of "Thu\, 25 Jun 2009 01\:49\:13 +0200")
Message-ID: <824ou3mnb2.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko:

> Some people want to unset CONFIG_PROC_FS, and still have
> working POSIX compatible shell.

Nowadays, the dynamic linker requires a mounted /proc with
/proc/self/exe for some features (notably $ORIGIN handling).  So it's
not self-exec only that doesn't work if /proc isn't there.  I guess
the kernel must make sure that /proc is always there (unlikely), or we
need a different mechanism to get this data.

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
