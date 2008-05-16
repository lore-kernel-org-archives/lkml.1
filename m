Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYEPJuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYEPJuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYEPJuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:50:44 -0400
Received: from mail151.ix.emailantidote.com ([89.167.219.151]:1305 "EHLO
	mail1.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753205AbYEPJul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:50:41 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2008 05:50:41 EDT
Message-ID: <482D5547.4000208@draigBrady.com>
Date: Fri, 16 May 2008 10:35:03 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Roland <devzero@web.de>
CC: tvrtko@ursulin.net, pernegger@gmail.com, snitzer@gmail.com,
       jengelh@computergmbh.de, zorglub_olsen@hotmail.com,
       renatoyamane@mandic.com.br, linux-kernel@vger.kernel.org
Subject: Re: WD doesn`t use disks with Linux - was Re: Re:Western Digital
 GreenPower drives and Linux
References: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com>
In-Reply-To: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 May 2008 09:35:05.0567 (UTC) FILETIME=[1F906EF0:01C8B738]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXSweep-Threat: Clean
X-MXUniqueID: 99ded16e-4e78-457a-b3f7-d4cac044ddcc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote a few notes about load cycles here:
http://www.pixelbeat.org/docs/hard_disk_reliability/

It's bad that the WD GreenPower doesn't support
`hdparm -B` setting its parameters, but I found I
didn't need to tweak these anyway.

I just got the distro to write less often to the drive
with the (rel)atime mount options. With that I got an
acceptable load cycle rate.

Pádraig.

