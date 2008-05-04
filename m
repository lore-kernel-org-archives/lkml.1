Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYEDTWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYEDTWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYEDTWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:22:39 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56366 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbYEDTWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:22:38 -0400
Message-ID: <481E0D2D.1030608@keyaccess.nl>
Date: Sun, 04 May 2008 21:23:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Richard <tuxbox.guru@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25 pci=noacpi
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183934.516655076@ldl.fc.hp.com> <4813B5AB.4060308@keyaccess.nl> <200804281507.38309.bjorn.helgaas@hp.com> <4816C605.4000601@gmail.com>
In-Reply-To: <4816C605.4000601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-04-08 08:53, Richard wrote:

> Using an AMD Sempron notebook (HP Compaq 6715b) single processor 
> machine,  It shuts down during bootup when ACPI is fully enabled.  I 
> added pci=noacpi to the cmdline and it finally boots, but its extremely 
> slow...  (kdm times out with error saying it took too long to load and 
> disables graphical)

Does booting with io_delay=0xed on the kernel command line fix it? If so, we 
need the output of

# dmidecode -s baseboard-manufacturer

and

# dmidecode -s baseboard-product-name

Rene.
