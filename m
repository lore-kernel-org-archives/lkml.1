Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbXFWL1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbXFWL1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXFWL0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:26:53 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:34655 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbXFWL0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:26:52 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: "Tom Spink" <tspink@gmail.com>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 13:26:34 +0200
User-Agent: KMail/1.9.7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <200706231300.18840.info@gnebu.es> <7b9198260706230405y5c4a173dx82a18fcc14a10272@mail.gmail.com>
In-Reply-To: <7b9198260706230405y5c4a173dx82a18fcc14a10272@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231326.34918.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Tom Spink wrote:
> Alberto,
>
> If you're feeling adventurous, grab the latest kernel and patch it
> with Ingo's scheduler: CFS.
>
> You may be pleasantly surprised.

Thanks, I might if I have to courage to patch and compile my own kernel :)

However, I'd also need to change all my applications to set them with the 
right priority to see the good results, so I think I might just wait until it 
lands in mainline.

Just to check if I understood everything correctly:

The mainline scheduler tries to be smart and guess the priority of each task, 
and while it mostly hits the nail right in the head, sometimes it hits you 
right in the thumb.

Fair schedulers, on the contrary, forget about trying to be smart and just 
care about being fair, leaving the priority settings to where they belong: 
applications.

Is this more or less correct?

Alberto.

