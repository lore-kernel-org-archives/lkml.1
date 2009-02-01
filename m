Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZBAS7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZBAS7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 13:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZBAS7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 13:59:46 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:39802 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZBAS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 13:59:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JItkB6y0cco5gs0b5tSSyz5iqr9o06SJR0spG1RPXrrKSJR4Hv/yrceSrl7l2l585h
         RMALLfHus/RYQbkJBnc7qQd8j+AM4G5sojCGmcFJDgxfhGUXec6XYrRU3PrP7ftnmPMJ
         xtvADyOvrNpHdFPhF5uvqsWiQ3BNuZwnDc+MM=
MIME-Version: 1.0
Date: Sun, 1 Feb 2009 10:59:44 -0800
Message-ID: <5f695cd0902011059g518cc6d4of00b8e1e00fe67c5@mail.gmail.com>
Subject: Killing a kernel thread from user space ?
From: George Kumar <grgkumar4@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is it possible to kill a kernel thread from user space. Don't ask me
why do I need to do this. This is purely an experimental exercise, I
am not doing it because I am working on a practical problem. Thing is
that I wrote a kernel module and now it is hung in a kernel thread
somewhere doing udelay(), fortunately since I am on preemptible kernel
 my machine is not frozen,
but still I saw that doing a kill -9 on this process has no effect.
How about if I insert another kernel module and kill this busywait
thread from inside the kernel space. In effect how do you execute
"kill -9" from one kernel thread to misbehaving kernel thread.

thanks.
george
