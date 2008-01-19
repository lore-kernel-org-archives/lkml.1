Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYASSz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYASSz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYASSzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:55:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:35621 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751043AbYASSzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:55:22 -0500
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 19 Jan 2008 19:55:20 +0100
From: "Lars Callenbach" <lars.callenbach@gmx.de>
Message-ID: <20080119185520.208350@gmx.net>
MIME-Version: 1.0
Subject: linux device ordering at boot time
To: linux-kernel@vger.kernel.org
X-Authenticated: #7374987
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX188c4AqV2Y8o2UhWfMcctRYax0lpD/La/Cha9675S
 RHyawSevxOEjWYrYMd90SgIO+aWdyO1Gu6RQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: oHWrclgceWUoQePpA3VzOQ8xU3U4N08k
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question concerning the ordering of devices during the boot process and I hope that the kernel mailing list is the right place for this question.
In my computer are two raid controllers with one raid array connected to each of them (/dev/sda, /dev/sdb). In the debian 2.6.18 boot process the ordering is root @ /dev/sda and data are on /dev/sdb. This behaviour has changed in the plain 2.6.23.1 (and 2.6.23.8) kernel. The /dev/sd(a|b) devices have switched so that root @ /dev/sdb. So my standard fstab does not work.
What determines the device ordering during the boot process? What is a workaround for this problem?

Thank you very much for some hints,
   Lars

-- 
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser
