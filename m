Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbXFOGdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbXFOGdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbXFOGdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:33:09 -0400
Received: from eazy.amigager.de ([213.239.192.238]:47144 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbXFOGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:33:08 -0400
Date: Fri, 15 Jun 2007 08:33:08 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: rtc_cmos: error after first write to wakealarm
Message-ID: <20070615063308.GA18089@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the following strange behaviour with rtc_cmos:

$ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
bash: echo: write error: Device or resource busy
$ rmmod rtc_cmos
$ modprobe rtc_cmos
$ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
$ echo 1181934240 > /sys/class/rtc/rtc0/wakealarm
bash: echo: write error: Device or resource busy
$

The kernel is git eedab661a51966c454e38c17266a531aa58b4a98 (something
after 2.6.22-rc4).

Regards,
Tino
