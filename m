Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbYCFLoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbYCFLoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYCFLoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:44:09 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:2167 "EHLO
	smtp2.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755330AbYCFLoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:44:08 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 06:44:08 EST
Message-ID: <47CFD6B0.4020602@draigBrady.com>
Date: Thu, 6 Mar 2008 11:34:08 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
 the disk image
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Mar 2008 11:34:12.0121 (UTC) FILETIME=[FFE9C890:01C87F7D]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXUniqueID: 2dcb21ef-9755-4192-8641-f235382511db
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> This patch allows to use loop device with partitionned disk image.
> 
> Original behavior of loop is not modified.
> 
> A new parameter is introduced to define how many partition we want to be
> able to manage per loop device. This parameter is "max_part".

I like it!
Shouldn't we set max_part to non zero by default though?

Hopefully I can throw away my loopback partition mounting script soon :)
http://www.pixelbeat.org/scripts/lomount.sh

cheers,
Pádraig.
