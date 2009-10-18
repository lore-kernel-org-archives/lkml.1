Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZJRIJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZJRIJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZJRIJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:09:31 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35473 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZJRIJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=l7xL14hYd+eZ/pua5oYPUoCh0Mgj0DpsaK6BRKopdts1tkL7QScG/uYGCKr87KAK2h
         qWMaM1YnYFK1g9wmcByE0mMR+KtybeSfV0VbX9SOAlPNTu7G8XqN4a/aWZRvR3X6NzHQ
         WP9vQNRK7zPDtf5PngRQlaIE0MJKxtBfyyDjM=
Message-ID: <4ADACD3A.9020803@gmail.com>
Date: Sun, 18 Oct 2009 10:09:30 +0200
From: Carmelo Amoroso <carmelo73@gmail.com>
Reply-To: carmelo73@gmail.com
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Fast LKM symbol resolution with SysV ELH hash table
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm just sending this message to report about a work I've recently done
to speed-up symbol resolution for modules by using a SysV ELF hash table
(without relying upon binutils support).
This work has been presented few days ago at the Embedded Linux Conference Europe.

Patches are already publicly available for 2.6.23 kernel @STLinux git
(http://git.stlinux.com/?p=stm/linux-sh4-2.6.23.y.git;a=summary)

For 2.6.30 already ported but not yet available.

Benchmarks have shown an average reduction of 96% in time spent for symbol resolution
(that is 25x faster).

All details can be found at
http://tree.celinuxforum.org/CelfPubWiki/ELCEurope2009Presentations?action=AttachFile&do=view&target=C_AMOROSO_Fast_lkm_loader_ELC-E_2009.pdf

I'm working to update them to mainline and post for review and discussion.
We are also working right now to update this work too to use GNU hash instead of SysV ELF hash

Carmelo
