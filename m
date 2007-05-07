Return-Path: <linux-kernel-owner+w=401wt.eu-S966172AbXEGSuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966172AbXEGSuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965985AbXEGSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:50:14 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:1155 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838AbXEGSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:50:13 -0400
From: James Cloos <cloos@jhcloos.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v10
In-Reply-To: <m3abwgqy5m.fsf@lugabout.jhcloos.org> (James Cloos's message of
	"Mon\, 07 May 2007 14\:35\:42 -0400")
References: <20070507163342.GA3502@elte.hu>
	<m3abwgqy5m.fsf@lugabout.jhcloos.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.0 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:070507:linux-kernel@vger.kernel.org::xD+6wjuFvvBLD2+i:000000000000000000000000000000000CbLo
X-Hashcash: 1:23:070507:mingo@elte.hu::29DMJnhlOvDSdguZ:0000IedX
Date: Mon, 07 May 2007 14:49:33 -0400
Message-ID: <m34pmoqxij.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

|> git checkout -b git checkout -b cfs v2.6.21

Damn, sorry about the typo.  That should of course be:

#!/bin/sh
git clone -l -s -n \
 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git \
 2.6.21-cfs-master
cd 2.6.21-cfs-master
git checkout -b cfs v2.6.21
git pull git://people.freedesktop.org/~cloos/cfs-2.6.git
git checkout master
git pull . cfs


-JimC
