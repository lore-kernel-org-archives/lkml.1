Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZASOFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZASOFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZASOFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:05:00 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57386 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZASOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JX/F486OyHbmNFF+nVHfg812lNF6nvVqJVeVvKeQzD3PjVscRO22EvdK429WJP5go1
         586fE0gWNeiEmxbw7bjfdGvYVUaW9lx/Z65MrM7KuQ4rvqRVmbKhv5DfBVLCyJxRAyDY
         XE2KJ3puPAq5xXX37sS9d9b8LRRpOOhs3/5Oo=
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 15:04:54 +0100
Message-ID: <519a8b110901190604l4c248ea2n88a117a064c35fac@mail.gmail.com>
Subject: wrong sym link with out-of-tree build with 2.6.28
From: xming <xmingske@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am building kernels on x86 and there is a problems with include2/asm
symbolic link
when building the with 'make O=./HOST".

- with 2.6.28.x the include/asm-x86 is moved to arch/x86/include/asm
  so this code is no more valid:
  ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;

That line of code should be made ARCH aware? I don't know how to do that, I can
only change that for x86 only.

BTW: I am not subscribed to lkml, please CC when replying, thanks

xming
