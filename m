Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbZASUvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbZASUvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZASUvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:51:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbZASUvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:51:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
Date: Mon, 19 Jan 2009 21:50:58 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
References: <20090119202423.GA7070@ucw.cz>
In-Reply-To: <20090119202423.GA7070@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192150.59438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Pavel Machek wrote:
> Hi!
> 
> In 2.6.29 (and probably earlier) kernels, booting in docking station
> results in undocked s2ram failing.
> 
> Problem seems to be that hda (cdrom in dock) is not deregistered
> during undock, and that hda driver loops spitting error messages at
> 'too-fast-to-read' rate when suspend with missing hda is attempted.

What driver do you mean exactly?  Old-IDE I would guess.

Does this also happen with a PATA/libata driver?

Rafael
