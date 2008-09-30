Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYI3KrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYI3KrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYI3KrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:47:08 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:25131 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYI3KrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:47:08 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: CD tray closes spontaneously after opening it
Date: Tue, 30 Sep 2008 12:47:04 +0200
User-Agent: KMail/1.9.9
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301247.05367.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2008 10:47:06.0100 (UTC) FILETIME=[E1653340:01C922E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm late reporting this mainly because until now I wasn't sure whether 
this was a kernel issue or not.

Since 2.6.27 I've had several times, but not always, that after I open the 
CD tray by pressing the eject button it spontaneously closes after a 
short delay. The delay varies between ~0 and ~2 seconds.

A few times this has resulted in a DVD getting stuck halfway out because I 
had already staring taking it out after playing it with vlc.

I've now also seen this happen two times while vlc was not running which 
makes the kernel the prime suspect.

Are you aware of any likely culprits I could try reverting?

System is running x86_64 current git, debian unstable.

The system has two CD drives:
- one normal IDE DVD drive on an Intel ICH7 controller (8086:27df); this
  is the one I've seen the issue with
- one SATA DVD writer, also on Intel ICH7 (8086:27c1); I haven't seen the
  issue with this one but I only use it very rarely

Cheers,
FJP
