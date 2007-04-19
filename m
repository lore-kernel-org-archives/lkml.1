Return-Path: <linux-kernel-owner+w=401wt.eu-S2993185AbXDSI4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993185AbXDSI4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161305AbXDSI4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:56:05 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:61344 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224AbXDSI4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:56:04 -0400
Date: Thu, 19 Apr 2007 10:57:50 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Wrong free clusters count on FAT32
Message-ID: <20070419085750.GA2833@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    I have a portable device with a FAT32 formatted hard disk in it, and
everytime I delete a file in the device *using the device itself to do
it* the device increases its count of free space and if I plug the
device in a Windows system, Windows agrees on the free space. Linux
doesn't. Linux believes that the files are still there ocuppying space,
and I have to run fsck.vfat to fix the problem.

    As far as I've seen, the device is probably not updating correctly
the list of free clusters, but it doesn't seem to worry about it,
neither does Windows. So my question is: is there any way of making
Linux "bug compatible" with Windows? If Windows itself don't worry about
the free cluster count and computes the free space in some other way,
then it can be done. I haven't seen anything in mount(8) neither
googling.

    Apart from not using the device itself to delete files (and probably
not using Windows for that, either) and to run fsck.vfat now and then,
is anything I can do to avoid this problem?

    Thanks a lot in advance :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
