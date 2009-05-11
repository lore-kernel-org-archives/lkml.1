Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZEKAzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZEKAzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 20:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZEKAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 20:55:23 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:33472 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZEKAzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 20:55:23 -0400
From: hooanon05@yahoo.co.jp
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Q. Switch open_exec() and sys_uselib() to do_open_filp()
Date: Mon, 11 May 2009 09:55:17 +0900
Message-ID: <29926.1242003317@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By the commit 6e8341a11eb21826b7192d0bb88cb5b44900a9af
"Switch open_exec() and sys_uselib() to do_open_filp()",
FMODE_EXEC flag is passed to struct file. I have no objection nor
question about that.

But it is set to file->f_flags instead of f_mode.
Is this intended behaviour?


J. R. Okajima
