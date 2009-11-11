Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbZKKSHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbZKKSHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758109AbZKKSHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:07:22 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49563 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbZKKSHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:07:21 -0500
Date: Wed, 11 Nov 2009 19:07:18 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20091111180718.GH3495@enneenne.com>
Mail-Followup-To: Richard Purdie <rpurdie@rpsys.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Defining led's triggers as separate class
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it could be sane moving triggers core from leds directory and defining
them as a separate class in order to be used by other subsystem?

For instance I have a voltage regulator (which should be logically
implemented into current regulator class) who must be enabled/disabled
when the LCD is turned on/off... if the driver was implemented as led
class then I can use the trigger ledtrig-backlight.c but as regulator
I can not.

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
