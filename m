Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYDTPu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYDTPu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 11:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYDTPut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 11:50:49 -0400
Received: from mx1.ukfsn.org ([77.75.108.10]:42391 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751104AbYDTPus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 11:50:48 -0400
Date: Sun, 20 Apr 2008 16:50:45 +0100
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org
Subject: Peculiar mouse freeze -> psmouse.c: bad data from KBC
Message-ID: <20080420165045.3cece588@linuxamd.linicks.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Maybe nothing, but thought I would report.

I run via power-strip/filter/spike protector

Updated to 2.6.25 (via git) yesterday:

2.6.25 #26 Fri Apr 18 07:56:55 BST 200

Module                  Size  Used by
nouveau               154556  1
drm                   136160  2 nouveau

Just now, a bit of thunder in Pompey, England. I was using firefox at
the time mouse froze.  I do run latest firefox cvs, so presumed a
possible ff crash, BUT, mouse was stuck.

I could use ctrl+alt+fn keys to vt, and also alt+n in fluxbox to get
new workspace and carry on in IRC etc..  Keyboard worked fine - mouse
was AWOL though.

One message in logs.

Apr 20 15:13:40 linuxamd kernel: psmouse.c: bad data from KBC - timeout

The mouse all of a sudden worked again after 90 seconds or so...

Ideas?

Nick
-- 
Free Software Foundation Associate Member 5508
