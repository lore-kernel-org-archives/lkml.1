Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYKJBMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYKJBMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 20:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYKJBMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 20:12:12 -0500
Received: from smtp.freemail.gr ([81.171.104.132]:45123 "EHLO smtp.freemail.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbYKJBML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 20:12:11 -0500
X-Greylist: delayed 639 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2008 20:12:10 EST
Message-ID: <491787A0.5050901@freemail.gr>
Date: Mon, 10 Nov 2008 03:00:16 +0200
From: John K <trv@freemail.gr>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: /proc/ksyms and /proc/kallsyms relationship?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/ newbie question below, if not interested, please ignore /

Hello,

In kernel 2.4, there was a /proc/ksyms file. This file, if I understand
correctly, was a method to access the kernel's public symbol table. What
was displayed had all the public kernel's symbols (variables,
functions..) and its associated global addresses, along with some other
usefull stuff, like a CRC value, and the module exporting every specific
symbol.
Fine until this point.

In 2.6 kernels, /proc/ksyms disappeared. Many sources suggest that it
was replaced by the /proc/kallsyms file.
BUT this file seems to be something completely different, and I haven't
figured out in what way it is different. It seems that it's not the
kernels public symbols table.

So, some questions to anyone that knows more on this:

1. Is my description of the functionality of /proc/ksyms in 2.4 kernels
correct?

2. What exactly the /proc/kallsyms file contains? Why does this file
exist and how is it used?

3. Why was there this change in name and behavior of the file?

4. If one wants to find out what are the exported symbols from some
module, so to know which symbols can he use in a future module, how can
he achieve this?

>From what I understand about /proc/kallsyms, it contains even the
symbols that are not exported using EXPORT_SYMBOL(symbol_name).
/proc/ksyms, contained every symbol except those that were not
exported (considering the export all default policy in 2.4, in contrast
with the export none policy of 2.6)

/I've already asked about this in kernelnewbies mailing list, but did
not get any useful answer. I also could not find any usefull answers
anywhere on new (and in kernel books). Most references say "just use
/proc/kallsyms instead of /proc/ksyms.

Sorry for the extra long post
Thanks & regards
