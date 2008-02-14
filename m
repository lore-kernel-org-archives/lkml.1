Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbYBNC4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbYBNC4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYBNC4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:56:30 -0500
Received: from mail.tmr.com ([64.65.253.246]:39285 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYBNC43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:56:29 -0500
Message-ID: <47B3AE23.8030506@tmr.com>
Date: Wed, 13 Feb 2008 21:57:39 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Grzegorz Chwesewicz <ceho@chilan.com>
CC: linux-kernel@vger.kernel.org, chilek@chilan.com
Subject: Re: [BUG] Problem with recording on hda-intel (sata_sil or hda-intel
 bug) - HP nx6325
References: <200802052015.23170.ceho@chilan.com>
In-Reply-To: <200802052015.23170.ceho@chilan.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grzegorz Chwesewicz wrote:
> 	Hi. 
> Problem description:
> 
> I have a problem with recording on HP nx6325 notebook (hda-intel with AD1981HD 
> codec). Playback works fine, but after 5-10 min. of recording microphone 
> stops working (playback works all the time). Unloading and loading sound 
> modules fixes problem, but only for another 5-10 minutes. This problem exists 
> from more than a year (at least from 2.6.17.13 kernel). In [1] we came to 
> conclusion that this problem is ralated to IRQ sharing [2] (HDA Intel is on 
> the same IRQ as sata_sil). 
> 
> How to reproduce the problem:
> 
> 1) on one console run arecord and see the output (You should see some garbage)
> 2) on another console run cat /etc/*
> 3) at once arecord on the first console gives no output
> 
> So, doing lot of hdd I/O occurs problem with mic.
> 
I had problems a few years ago with USB stopping when the screen saver 
kicked in, just a wild thought.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
