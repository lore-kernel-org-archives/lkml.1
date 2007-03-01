Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbXCALc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbXCALc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964983AbXCALc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:32:58 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60220 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981AbXCALc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:32:57 -0500
Date: Thu, 1 Mar 2007 13:32:55 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Chris Rankin <rankincj@yahoo.com>
cc: Takashi Iwai <tiwai@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-devel] [BUG] Linux 2.6.20.1 - unable to handle kernel
 paging request - accessing freed memory?
In-Reply-To: <462787.14129.qm@web52911.mail.yahoo.com>
Message-ID: <Pine.LNX.4.64.0703011330330.29829@sbz-30.cs.Helsinki.FI>
References: <462787.14129.qm@web52911.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Thu, 1 Mar 2007, Chris Rankin wrote:
> Nope, no difference. Again, this happened while trying to start World of 
> Warcraft. However, this time there is no snd-rtctimer module in the 
> stack.

Please apply this patch to your kernel and try to reproduce:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/gregkh-driver-sysfs-crash-debugging.patch

It should give us a better clue which sysfs file is causing the oops.

			Pekka
