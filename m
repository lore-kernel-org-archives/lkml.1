Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbYLBHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbYLBHxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 02:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYLBHxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 02:53:09 -0500
Received: from cpsmtpo-eml05.KPNXCHANGE.COM ([213.75.38.154]:55033 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbYLBHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 02:53:08 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Tue, 2 Dec 2008 08:53:03 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200812020853.03978.elendil@planet.nl>
X-OriginalArrivalTime: 02 Dec 2008 07:53:04.0600 (UTC) FILETIME=[01CCFD80:01C95453]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending to list only as original attempt did not make it)

> The symptoms of the breakage are that sometimes the box hangs solid
> during resume, sometimes it hangs but can be rebooted by pressing
> Alt-SysRq-b, and sometimes it just powers off while resuming.  Still,
> it resumes correctly in about 75% of cases and that made the issue very
> hard to debug.
> [Interestingly enough, it was not reproducible with snd_hda_intel 
> unloaded, which made me think it was related to the driver, but
> evidently it wasn't.] 

This almost exactly describes problems I've been seeing on my HP 2510p. I 
never tried Alt-SysRq-b and have not seen the spontaneous power-off, but 
the percentage correct boots and relationship with the sound driver are 
spot on.

I worked around the sound driver relationship by using a very low power 
save setting so I can virtually count on it being disabled when I 
suspend.

I'll give your patch a go and report the results. Nice work!

Cheers,
FJP
