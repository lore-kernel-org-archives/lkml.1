Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYAABpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYAABpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 20:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYAABpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 20:45:45 -0500
Received: from main.gmane.org ([80.91.229.2]:34548 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYAABpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 20:45:45 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300 card); 2.6.23.1(vanilla)
Date: Tue, 01 Jan 2008 02:45:23 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.01.01.01.45.23.430875@wizards.de>
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no> <4777E08C.4000603@shaw.ca> <4779870E.5070507@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-174.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007 16:19:26 -0800, Linda Walsh wrote:

> [snip]
>     Another new "problem" (not as important) -- even though SATA disks are
> called with "sdX", my ATA disks that *were* at hda-hdc are now at hde-hdg.
> Devices hda-hdd are not populated in my dev directory on bootup.  Of

I think this is because the Promise SATA card also has one or more PATA
channels, so if the card is activated it takes precedence over your old
controller. But it should only be one channel, not four?
As for the other problem - I plan on adding such a card to one of my
systems during the week and might be able to contribute some findings.

Holger


