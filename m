Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbXKELPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbXKELPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXKELOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:14:52 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:4860 "EHLO
	iamp04-out.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbXKELOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:14:51 -0500
Message-ID: <472EFA1F.8040003@draigBrady.com>
Date: Mon, 5 Nov 2007 11:10:23 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Alberto Gonzalez <info@gnebu.es>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Laptop's HDD
References: <200711040002.25784.info@gnebu.es>
In-Reply-To: <200711040002.25784.info@gnebu.es>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Nov 2007 11:13:01.0244 (UTC) FILETIME=[D403D7C0:01C81F9C]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXUniqueID: 2dda4b87-929c-457a-aeca-9753e9ea0b9a
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Gonzalez wrote:
> Hi,
> 
> Maybe some of you have been hearing lately about a problem with laptop's hard 
> disk drives being killed by *insert Linux distro here* [1]

I asked about this on the fedora devel list:
http://www.redhat.com/archives/fedora-devel-list/2007-October/msg02324.html

I don't think the kernel should worry about this.
I don't even think distros should change the default settings of the BIOS/disk.

Up to and including Fedora 7 on my laptop, the disk did a load cycle
on average once every 48 seconds. Mounting the filesystems noatime changed this
to once every 108 seconds, which is a little aggressive still but not too bad.

Note fedora 8 will have the relatime option on by default for all filesystems.

Pádraig.
