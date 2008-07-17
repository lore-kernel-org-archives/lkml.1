Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYGQWl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYGQWl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYGQWlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:41:10 -0400
Received: from simmts12.bellnexxia.net ([206.47.199.141]:48109 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120AbYGQWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:41:09 -0400
X-Greylist: delayed 1779 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 18:41:08 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANtff0jP5+wq/2dsb2JhbACwaA
Date: Thu, 17 Jul 2008 19:11:20 -0300 (ADT)
From: Thomas Lucaw <aj881@chebucto.ns.ca>
X-X-Sender: ve1ttl@ttl.localnet
Reply-To: Thomas Lucaw <aj881@chebucto.ns.ca>
To: linux-kernel@vger.kernel.org
Subject: ide-cd or ide-scsi dmesg contradiction
Message-ID: <Pine.LNX.4.64.0807171844330.1320@ttl.localnet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, for some time I've noticed

giving the cmdline (to kernel at boot) "hdd=ide-scsi ..." I get

	ide-scsi is deprecated for cd burning! Use ide-cd and give dev=/dev/hdX as device

then changing to the suggested "hdd=ide-cd ..." I get

	ide_setup: hdc=ide-cd -- OBSOLETE OPTION, WILL BE REMOVED SOON!

Rather illogical to me :-)

I guess neither should be used, I can make my cdrom and dvd devices work 
without ok.

kernel 2.6.26

	Tom

