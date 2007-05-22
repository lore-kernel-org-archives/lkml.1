Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbXEVW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbXEVW4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXEVW4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:56:09 -0400
Received: from web90313.mail.mud.yahoo.com ([216.252.100.150]:21514 "HELO
	web90313.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755837AbXEVW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:56:08 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 18:56:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=eaIqeBfO6p6wCyZhAqqXxORfGtwEr5dLNdNx6btzhYv+Y6r5ebeO0BFvXHYlK+uWi/I4Q6LnZDI38iabCQ3eG1QTYjMpksqTKng6Lf/jpyENuewM7QZezqsXkJl9t7EkpnVwSWPIIkHkawU1RTxMcaBUUA1NARHqe58fZYr3EU4=;
X-YMail-OSG: ueOMrTAVM1kV_zqGVvNpOAuJo_alwnBKgkSNdtslB3lO1uxKQY7pVXPktsEFSrFftg--
Date: Tue, 22 May 2007 15:49:25 -0700 (PDT)
From: Y Khan <ykhanportland@yahoo.com>
Subject: class_device_create() and the mode of the device file in /dev.
To: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <288328.633.qm@web90313.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am porting a driver from 2.4 to 2.6. I have replaced
the call devfs_register() with class_create() and
class_device_create(). Now, udev is automatically
creating the device file in /dev.

The device file being created has a default mode of
0600. Is it possible to override this default mode
from inside the kernel. I do not want to do anything
in the configuration file for udev.

I could modify the attribute of the class and the
class device but I do not think that they will change
the default permissions for the /dev device file.

devfs_register() used to take a mode argument.

So, is there anyway of achieving this in 2.6.

-Y




       
____________________________________________________________________________________Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 
