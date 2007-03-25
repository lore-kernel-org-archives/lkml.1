Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbXCYI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbXCYI7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXCYI7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:59:24 -0400
Received: from tide.yandex.ru ([213.180.200.37]:41323 "EHLO tide.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbXCYI7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:59:23 -0400
Date: Sun, 25 Mar 2007 12:59:06 +0400 (MSD)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <460639DA.000001.20646@tide.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: problem: init_termios = tty_std_termios;
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.207.228
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just added 

"mydriver_tty_driver->init_termios = tty_std_termios"

to my init driver function.

Problem: But now I can't see data at user level application. It looks like flip_buffer needs to get termination character(or new line character) to push data to high level.

Which character should I add to flip_buffer to push data to high level? I tried to add '/n', it works, but after that user level gets '/n' as well. But I need something like a filter, to inform flip_buffer only, not user level application.

Thank you   
