Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbXKMWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbXKMWHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbXKMWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:07:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:52323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbXKMWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:07:39 -0500
Date: Tue, 13 Nov 2007 23:07:20 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: "Serge E. Hallyn" <sergeh@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Posix file capabilities in 2.6.24rc2
Message-Id: <20071113230720.22c6a036.chris@friedhoff.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.10.14; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/dFILJyOogJpDB1fFwLF38EZokQNzvYOpJJ/2
 OP6B5OViUTO0lO9eHT2cSt5YJWalbueZ8i5rqfx3DcpVLJ29W4
 7B9R6MLqIJbC0IHFW+mVM1wtF6uL3q6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

everything works as expected, but ...

closing X and no capabilities set for xinit does shutdown only the
windowmanager and not the X server (Xorg server 1.4)
Consolemessage is:
xinit:  Operation not permitted (errno 1): Can't kill X server


the xattr capability is removed, when the file is chown'ed.


Chris
--------------------
Chris Friedhoff
chris@friedhoff.org
