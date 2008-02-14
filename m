Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbYBNMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbYBNMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763083AbYBNMDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:03:50 -0500
Received: from mail.chilan.com ([82.160.213.101]:36888 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbYBNMDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:03:48 -0500
From: Grzegorz Chwesewicz <ceho@chilan.com>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [BUG] Problem with recording on hda-intel (sata_sil or hda-intel  bug) - HP nx6325
Date: Thu, 14 Feb 2008 13:03:28 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, chilek@chilan.com
References: <200802052015.23170.ceho@chilan.com> <47B3AE23.8030506@tmr.com>
In-Reply-To: <47B3AE23.8030506@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802141303.29261.ceho@chilan.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thursday 14 of February 2008 03:57:39 Bill Davidsen napisa³(a):
> Grzegorz Chwesewicz wrote:
> > 	Hi.
> > Problem description:
> >
> > I have a problem with recording on HP nx6325 notebook (hda-intel with
> > AD1981HD codec). Playback works fine, but after 5-10 min. of recording
> > microphone stops working (playback works all the time). Unloading and
> > loading sound modules fixes problem, but only for another 5-10 minutes.
> > This problem exists from more than a year (at least from 2.6.17.13
> > kernel). In [1] we came to conclusion that this problem is ralated to IRQ
> > sharing [2] (HDA Intel is on the same IRQ as sata_sil).
> >
> > How to reproduce the problem:
> >
> > 1) on one console run arecord and see the output (You should see some
> > garbage) 2) on another console run cat /etc/*
> > 3) at once arecord on the first console gives no output
> >
> > So, doing lot of hdd I/O occurs problem with mic.
>
> I had problems a few years ago with USB stopping when the screen saver
> kicked in, just a wild thought.

Hehe, we are now working on solution with Takashi :)

-- 
Greetings
Grzegorz Chwesewicz, Chilan 
mailto:grzegorz.chwesewicz@chilan.com
