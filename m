Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYHSDuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYHSDuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 23:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYHSDu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 23:50:28 -0400
Received: from internal.actusa.net ([208.83.100.16]:59032 "EHLO
	internal.actusa.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYHSDu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 23:50:28 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 23:50:28 EDT
Message-ID: <48AA4107.9090009@actusa.net>
Date: Mon, 18 Aug 2008 20:41:59 -0700
From: Stuart Sheldon <stu@actusa.net>
Organization: ACTUSA
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: "make prepare" in 2.6.26.2 not behaving?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all, think I found a little bug...

I recently was attempting to build 3rd party modules on a 2.6.26.2 
source tree after a "make clean" was run on the kernel source tree.

In the past I would run "make oldconfig prepare scripts" and then build 
and install the 3rd party module. All would work as expected.

And all started well with the 2.6.26.2 tree. The module built without 
error, but when I went to load it, it responded back with a version 
error on the console, and the dmesg was: "no symbol version for 
struct_module".

If I rebuild the entire kernel and modules in the source tree and then 
build the 3rd party module again, It builds and loads without issue.

I'm hoping this is a bug, as I use the prepare method of setting up 
source trees a lot. It saves me hours of time on my server farm.

Thanks in advance for listening,

Stuart Sheldon



