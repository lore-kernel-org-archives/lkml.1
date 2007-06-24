Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbXFXTgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbXFXTgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXFXTgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:36:39 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1839 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbXFXTgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:36:38 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Question about fair schedulers
Date: Sun, 24 Jun 2007 12:36:35 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEHBENAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200706230946.44023.info@gnebu.es>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 24 Jun 2007 12:37:04 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 24 Jun 2007 12:37:04 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alberto Gonzalez wrote:

> On Saturday 23 June 2007, Kyle Moffett wrote:
> > On Jun 22, 2007, at 18:07:15, Alberto Gonzalez wrote:

> > What this *actually* means is that you want the media player to have
> > higher priority than the DVD ripping program.  Ergo you should run
> > "nice +20 my_dvd_burner" or "nice +20 my_vorbis_encoder" under CFS or
> > other fair schedulers.
>
> Ok, that makes sense. The problem is that desktop users don't
> know about such
> things, so the ideal situation would be that the scheduler knows
> about it and
> does it for you.

I disagree. How could the scheduler know that you care more about the media
player than the DVD ripping program? Maybe you're just watching unimportant
stuff to waste time while anxiously waiting for the DVD rip to finish.

Why should the scheduler make assumptions about what's important to the
user? If the user has priorities, they should tell the scheduler.

DS



