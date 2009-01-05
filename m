Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbZAEC6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbZAEC6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZAEC6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:58:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:42817 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZAEC6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TrEt3NZjnbLzf3ZvPnvgNKj9gSMVHejk7YqWGy1eG/+qJ8NsU530K7Yo4CM/aaOerR
         62FXAlaMOYea3i5SA1HN5ql1qA6iJKp2BHDgFrUYVc26ClLD0fmMKn23Zg27Pse6RXgA
         KDa/SN3TW5DXIiR+qUNAGr5RgMWnOHrz+JS9g=
Message-ID: <f7848160901041858n5c6ac1ddvd7ed0db90a677835@mail.gmail.com>
Date: Sun, 4 Jan 2009 21:58:21 -0500
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Lock up - probably ALSA related
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After installing today's git my laptop has started to partially lock
up while listening to audio.  This laptop was previously running
distro kernel 2.6 (2.6.27.9-159.fc10.i686) without any trouble.

While listening to audio, after a few minutes (10-15) the audio will
loop. I can most times move the mouse and click on windows but no new
process will start in reasonable time and the terminal will repeat
each key twice (type d and it will take dd for example) and thus no
command can be executed. I tried pre-entering various useful sysrq
commands (t, l, d, u,c) and tried hitting enter after reproducing the
problem but that command goes nowhere. Even shutdown button which
normally pops up the Gnome shutdown dialog will do nothing. Machine
isn't pingable.

The problem is 100% reproducible - I just can't figure out a good way
to get some debug data out. This laptop doesn't have a serial and
doesn't have the sysrq key, so I was thinking about using the USB
Serial adapter - will USB serial console via null modem cable work
here if I build in the driver for the USB-Serial dongle and set the
right config options? (Found the usb-serial dongle in the basement but
null modem cable is yet to be arranged.)

Parag
