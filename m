Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYHRGLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYHRGLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHRGKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:10:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:15994 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYHRGKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JQhOyXuCElXxSfk16M1leE0+VnN0Nahmm0S6SQ4iDucCNQV97fPWC1+uPZC0FSLAsr
         eiSI8yfG7otoYxKShU2slLgitQ1foyuo3G51zBXhcjnv/N8HksZxyt5sBeMMDOyJG33C
         zr4V76i8pw3IWxM+SjzYTciEpoKTiT8eAR0pk=
Message-ID: <dd18b0c30808172310u7cf7836ai15e19485908ae0ce@mail.gmail.com>
Date: Sun, 17 Aug 2008 23:10:54 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: evdev.c(EVIOCGBIT): Suspicious buffer size 511,
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm noticing:
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64
bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
with rc-3 not with rc2.
Did the patch to synaptics, seems
my xorg is not reading /usr/X11R6/lib/modules/input/synaptics_drv.o
only /usr/lib/xorg/modules/input/synaptics_drv.so
is there any easy fix, or do I have to recompile xorg?
regards;

-- 
Justin P. Mattock
