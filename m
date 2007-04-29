Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXD2OVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXD2OVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbXD2OVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:21:55 -0400
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:2153 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933265AbXD2OVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:21:54 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Syren Baran <sbaran@gmx.de>
Subject: Re: Probable PCIE prob
Date: Sun, 29 Apr 2007 15:21:48 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
References: <1177790017.3649.23.camel@excalibur>
In-Reply-To: <1177790017.3649.23.camel@excalibur>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291521.48769.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 April 2007 20:53:37 Syren Baran wrote:
> Hi,
>
> i got a problem with the combination of an Asrock AM2NF4G-SATA2
> mainboard with a Radeon X1900 (chip 1002,724b) graphics
> card. /i386/pci/mmconfig.c reports a buggy bios (e0000000 is not
> E820-reserved). System crashes only happen when viewing films (neither
> xine nor mplayer run with root privileges) and independent of video
> drivers (framebuffer, vesa and fglrx). Logs dont show any anomalies
> before crashing. Anybody got a clue?

This is a pretty bizarre crash. It might be a hardware problem. Try running a 
load intensive task, something that heats your CPU up, for a long period. See 
if it lasts longer than 30 minutes..

Another thing you could try doing was eliminating X completely, by using 
mplayer on a vesafb console..

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
