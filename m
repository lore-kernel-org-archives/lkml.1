Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZABJHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZABJHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZABJGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:06:54 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:34868 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZABJGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:06:53 -0500
X-Greylist: delayed 1714 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 04:06:52 EST
Date: Fri, 2 Jan 2009 09:38:11 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: reiserfs broken with 2.6.28-17244-gb58602a
Message-ID: <20090102083645.GA3635@stiffy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux stiffy 2.6.28-marc-12264-g4a6908a
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just booted into a 2.6.28-17244-gb58602a kernel that is the currently recent
git code. The reiserfs fs has some major probs when booting this kernel. I just
--rebuild-tree 4 partitions which are OK now again. When booting my Gentoo box
says it cannot create an /etc/mtab~nnnn file and such. When I boot into stock
2.6.28, however, anything is OK. I re-tested that 3 times. Anytime I boot into
the git kernel the messages occur and I shutdown the box via acpid (power
button) as quick as I can.

/var/log/messages has some of these for me:

Jan  2 09:23:16 stiffy [   45.485204] ReiserFS: warning: vs-500: unknown uniqueness -190812612
Jan  2 09:23:16 stiffy [   45.485213] ReiserFS: warning: vs-500: unknown uniqueness -190812612
Jan  2 09:23:16 stiffy [   45.485217] ReiserFS: warning: vs-500: unknown uniqueness -190812612
Jan  2 09:23:16 stiffy [   45.485221] ReiserFS: warning: vs-500: unknown uniqueness -190812612
Jan  2 09:23:16 stiffy [   45.485224] ReiserFS: warning: vs-500: unknown uniqueness -190812612
Jan  2 09:23:16 stiffy [   45.485228] ReiserFS: warning: vs-500: unknown uniqueness -190812612
Jan  2 09:23:16 stiffy [   45.485233] ReiserFS: hda7: warning: vs-500: unknown uniqueness -190812612[4772178 230 0xf7538800 UNKNOWN] not found

Please let me know if I can help out with some tests or something. Please also
CC me as I'm currently not in the list ... :/

Marc

-- 
Marc Koschewski
