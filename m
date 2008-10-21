Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYJUTvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYJUTvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJUTu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:50:56 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:54563 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYJUTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:50:56 -0400
Message-ID: <48FE30D8.6050705@freescale.com>
Date: Tue, 21 Oct 2008 14:43:20 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org, Kumar Gala <kumar.gala@freescale.com>
Subject: Re: Best method for sending messages to user space?
References: <48FE1741.1000502@freescale.com> <e9c3a7c20810211114w5be330d3h35f859b4ea8f8af7@mail.gmail.com>
In-Reply-To: <e9c3a7c20810211114w5be330d3h35f859b4ea8f8af7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:

> I really like the sysfs_notify() approach that Neil Brown has put
> together for delivering md-raid events.

Is there any documentation for sysfs_notify?  It doesn't appear to do anything
whenever I call it.

>  Now with 2.6.28 you will be
> able do this from an atomic context with sysfs_notify_dirent() [1].

That sounds like something I could use.

Kumar, can you update the repository I'm using to include sysfs_notify_dirent()?

-- 
Timur Tabi
Linux kernel developer at Freescale
