Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbYBBRt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbYBBRt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYBBRtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:49:18 -0500
Received: from sas5.t-com.sk ([213.81.152.135]:53043 "EHLO sas4.stonline.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023AbYBBRtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:49:17 -0500
X-Greylist: delayed 993 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2008 12:49:17 EST
Date: Sat, 02 Feb 2008 18:29:59 +0100
From: Michal Zachar <mgzachar@mail.t-com.sk>
Subject: make menuconfig broken
To: linux-kernel@vger.kernel.org
Message-id: <200802021830.00335.mgzachar@mail.t-com.sk>
Organization: home
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I dont know if it was not reported yet or not fixed yet.

It apeared about in version 2.6.20.xx or there about so it is broken already 
awhile.

Problem:

changing settings manualy seem to work. Where problem apears is that loading 
alternate config file changes settings but on exit '.config' file is not 
writen and one is advised to run make which bombs.

Also window:	Do you wish to save your new kernel configuration ?
				<ESC><ESC> to continue
					<YES>	<NO>

does not apear.

Solution for me is before exit to change content of window (Save an Alternate 
Configuration File) to .config. And only then file .config is writen.

It seems that contents of bouth Load and save Alt Conf File are set to same 
using Load. It may actualy write to alternate file instead to .config 

One which I'm compiling at present is 2.6.23.14 version

Regards Michael
