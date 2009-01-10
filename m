Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZAJWAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZAJWAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZAJWAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:00:34 -0500
Received: from smtpauth17.prod.mesa1.secureserver.net ([64.202.165.29]:50108
	"HELO smtpauth17.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751476AbZAJWAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:00:34 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2009 17:00:33 EST
From: "Andrew S. Johnson" <andy@asjohnson.com>
To: linux-kernel@vger.kernel.org
Subject: TMDC Joystick no longer works in kernel 2.6.28
Date: Sat, 10 Jan 2009 15:53:40 -0600
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101553.40515.andy@asjohnson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up through kernel version 2.6.27.9 I have had no problems with
my joystick on the game port.  Now with 2.6.28, the game port
is recognized when the gameport and ns558 modules load, but
loading the tmdc module doesn't also automatically load joydev,
and even loading joydev manually doesn't give me a working
joystick.  There are no error messages in dmesg, /var/log/messages, 
or /var/log/syslog.  This is on Slackware 12.1, so I don't think
it's a distro issue.  Do I need to do something different than
in the past to make it work, or is there some debug I can turn
on to give more info?

Please CC me.

Thanks,

Andy Johnson
Luling, Louisiana
