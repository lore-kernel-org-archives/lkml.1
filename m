Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbXHCWVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbXHCWVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762605AbXHCWV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:21:29 -0400
Received: from jan-robben.demon.nl ([83.160.142.71]:54417 "EHLO mail.robben.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757625AbXHCWV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:21:29 -0400
X-Greylist: delayed 1393 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2007 18:21:28 EDT
Message-ID: <46B3A4F5.2000708@gert.robben.nu>
Date: Fri, 03 Aug 2007 23:58:13 +0200
From: Gert Robben <lkml@gert.robben.nu>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: snd-au8830: dead after software suspend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After a suspend-resume cycle (using Suspend2), my sound card doesn't 
work anymore. It works again after reloading the module.

dmesg, initial boot:
> Linux version 2.6.22-ck1
----8<----
> PCI driver au8830 lacks driver specific resume support.

dmesg, after resume, trying to use the card:
> vortex: ac97 codec stuck busy

Thanks for any help!

Gert Robben
