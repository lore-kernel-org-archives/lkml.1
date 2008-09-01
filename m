Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYIASVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYIASVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYIASVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 14:21:12 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:36212 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYIASVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 14:21:12 -0400
Message-ID: <54175.166.70.238.45.1220291588.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 1 Sep 2008 11:53:08 -0600 (MDT)
Subject: 2.6.27-rc5 make distclean isn't really clean
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems to have been this way for the past few kernels.

'make distclean' leaves the following files laying around which tend to
junk up patches when running diff against a clean source tree:

arch/x86/boot/compressed/vmlinux.bin.all
arch/x86/boot/compressed/vmlinux.relocs
arch/x86/boot/compressed/relocs


Jeff

