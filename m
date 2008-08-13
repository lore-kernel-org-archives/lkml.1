Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYHMIcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYHMIcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYHMIb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:31:56 -0400
Received: from n61.bullet.mail.sp1.yahoo.com ([98.136.44.37]:35955 "HELO
	n61.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751802AbYHMIbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:31:55 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 547104.10581.bm@omp209.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=Y3Y1k/K2mflx93H7Ve4ZI0kfmy8p5Oco7Zxd/NB/M4Z8wxqzW2ckEtyk4FfZayFU2OfsWmR2O0bGskWIYEoXPLYW5CmGK1XvjnpelXx2V6i5Gyb1t/Tv6+U9yAhTW/heZxmAzUZ/5qlcqDVsS24i+09wzHsDw9XCEnOWq2gfTrc=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 13 Aug 2008 01:25:14 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: Problems w/UHCI-WLAN and bulk USB DVB stream
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <500888.76278.qm@web46106.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin moin,

I've noticed that with recent kernels (mac80211), my zd1211rw
device, when `ifconfig up'ed and connected to a UHCI (USB 1.x)
interface, causes problems when recording from a DVB full-
transport-stream device (PID filtering at the linux end) that
is connected via EHCI (approx 36Mbit/sec bandwidth).  The
recorded files show corruption relatively frequently.

If I connect the zd1211rw device to a USB2 hub, which also
happens to have the DVB receiver connected to it as well, I see
no such problems with the WLAN active.  Also, without the
WLAN device `ifconfig up'ed on UHCI, I see no problems.

Is this something I should expect (use of UHCI interface will
block EHCI from receiving bulk data properly), or is there a
problem somewhere that should be able to be fixed?

In addition, I've noticed (but not measured) that when I use
`mplayer' to check the files, with the WLAN interface running,
it appears to run significantly slower -- it's an old machine
that can't quite push 25 fps of good-quality video, but looks
to drop to (estimated) half or a third of that with WLAN active
on UHCI.


I have not yet taken the time to try older kernels with the
WLAN interface running yet, as when I was testing those kernels,
I didn't realize the wireless adapter was the source of my
recent corrupted recordings.

Nor have I analysed the recordings against good recordings to
identify the nature of the corruption.  I've just started to
use the single UHCI port for something else, as a quick'n'dirty
workaround.

Other bulk data on that USB hub seems mostly unaffected, though
the file being written with the corrupt data is also attached to
that USB hub with the DVB receiver.

This is the case on a git kernel from one or two days ago.


thanks,
barry bouwsma


      

