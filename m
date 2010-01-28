Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572Ab0A1BGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0A1BGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229Ab0A1BGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:06:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab0A1BGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:06:35 -0500
Message-ID: <4B60E317.4080108@infradead.org>
Date: Wed, 27 Jan 2010 23:06:31 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
       linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       dean <dean@sensoray.com>
Subject: Re: [PULL] firmware for Sensoray s2255 driver
References: <4B60B721.1020908@redhat.com>
In-Reply-To: <4B60B721.1020908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Mauro Carvalho Chehab wrote:
> The following changes since commit c024a251e1dd1a39de610bbdc2af65b36e42637d:
>   David Woodhouse (1):
>         Merge from fixed from-kernel tree to fix Matrox firmware binaries
> 
> are available in the git repository at:
>
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Sensoray sent us two more firmwares, under the same licence. So, I've added them 
on my tree also.

For one of his driver to work, they'll need also the Micronas go7007 firmware.

This firmware gives redistribution rights, but the condition for it is unusual: it 
requires that the README file of their public driver to be shipped together with the 
firmware. So, I added the clauses at WHENCE licence (based on their readme file), and
added their unmodified README, just renaming it as "README.go7007".
I hope that's the right way of doing it.

The 2 Sensoray patches, plus the go7007 firmware are at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git go7007

So, please pull from it if you're comfortable.

This is the contents of the "go7007" branch:

Mauro Carvalho Chehab (3):
      Firmware for Sensoray s2255 webcam drivers
      Additional firmwares for Sensoray s2255 webcam drivers
      Add firmwares for go7007 driver

 README.go7007   |  375 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 WHENCE          |   33 +++++
 f2255usb.bin    |  Bin 0 -> 180760 bytes
 go7007fw.bin    |  Bin 0 -> 30800 bytes
 go7007tv.bin    |  Bin 0 -> 124668 bytes
 s2250.fw        |  Bin 0 -> 9508 bytes
 s2250_loader.fw |  Bin 0 -> 1092 bytes
 7 files changed, 408 insertions(+), 0 deletions(-)
 create mode 100644 README.go7007
 create mode 100644 f2255usb.bin
 create mode 100644 go7007fw.bin
 create mode 100644 go7007tv.bin
 create mode 100644 s2250.fw
 create mode 100644 s2250_loader.fw

---

If, however, you think that the way the go7007 were imported is incorrect, then
please pull at least the two Sensoray patches from the "master" branch.

This is the contents for just the "master" branch, at
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Mauro Carvalho Chehab (2):
      Firmware for Sensoray s2255 webcam drivers
      Additional firmwares for Sensoray s2255 webcam drivers

 WHENCE          |   14 ++++++++++++++
 f2255usb.bin    |  Bin 0 -> 180760 bytes
 s2250.fw        |  Bin 0 -> 9508 bytes
 s2250_loader.fw |  Bin 0 -> 1092 bytes
 4 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 f2255usb.bin
 create mode 100644 s2250.fw
 create mode 100644 s2250_loader.fw
