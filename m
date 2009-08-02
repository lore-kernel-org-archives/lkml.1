Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZHBPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZHBPin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 11:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZHBPim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 11:38:42 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:51550 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZHBPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 11:38:41 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, <linux-fsdevel@vger.kernel.org>
Subject: Re: [review] fat/nls: Fix handling of utf8 invalid char
References: <Pine.LNX.4.44L0.0908021117160.10433-100000@netrider.rowland.org>
Date: Mon, 03 Aug 2009 00:38:39 +0900
In-Reply-To: <Pine.LNX.4.44L0.0908021117160.10433-100000@netrider.rowland.org>
	(Alan Stern's message of "Sun, 2 Aug 2009 11:21:14 -0400 (EDT)")
Message-ID: <87ocqyfcow.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

>> So, to make sure, could you review this if you have time?
>
> I don't know about the changes to namei_vfat.c, but the changes to 
> nls_base.c look fine.  And since, as you say, VFAT is the only user of 
> utf8s_to_utf16s(), it shouldn't cause any problems elsewhere.

Thanks for reviewing this.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
