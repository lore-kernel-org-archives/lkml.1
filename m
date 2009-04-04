Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZDDP1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZDDP1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 11:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbZDDP1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 11:27:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43681 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZDDP1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 11:27:36 -0400
Date: Sat, 4 Apr 2009 16:27:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, shurik@gwu.edu
Subject: qcserial/gobi firmware loader
Message-ID: <20090404152731.GA5080@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151237.GA25994@suse.de> <20090403164551.GA23689@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403164551.GA23689@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've reimplemented Alexander's shell scripts for firmware loading in C 
and added a udev rule to automatically trigger the loading[1]. Thanks to 
Sergey's hint I've added checksumming support so it should work on other 
firmwares as well. The firmware needs to be obtained somehow and then 
put in /lib/firmware/gobi, but should then automatically load when the 
device is ready.

You can download this at http://www.codon.org.uk/~mjg59/gobi_loader/

[1] The firmware to be loaded depends on the user's network, so I can't 
think of an especially clean way of doing this in kernel.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
