Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYGYVhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYGYVhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbYGYVhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:37:13 -0400
Received: from c-68-35-23-177.hsd1.nm.comcast.net ([68.35.23.177]:41364 "EHLO
	deneb.dwf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYGYVhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:37:11 -0400
Message-Id: <200807252137.m6PLbAkj008998@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: linux-kernel@vger.kernel.org
Subject: Confused: 'tail -f' how can this happen???
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 25 Jul 2008 15:37:10 -0600
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I dont understand this at all.
I was debugging another problem, and had a 'tail -f' running on my maillog 
file.
It showed data down to the  present, namely 15:18:18

Something had gone by fast enough that I brought the maillog up in an editor
but IT only showed data down to 14:02:16

Looking at the 'ls' of /var/log, the maillog file shows a write date of 14:02.

If I do a 2nd tail -f, it too stops at 14:02.

What is going on with the file system to cause the bizare behaviour?
Why cant I see ALL the data in maillog, or why could I see it only once?

Confused.
-- 
                                        Reg.Clemens
                                        reg@dwf.com


