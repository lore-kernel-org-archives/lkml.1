Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYBFOgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYBFOgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYBFOgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:36:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYBFOgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:36:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: any cpu hotplug changes in 2.6.24-current-git?
Date: Wed, 6 Feb 2008 15:34:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20080206125807.GB26817@elf.ucw.cz>
In-Reply-To: <20080206125807.GB26817@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061534.35790.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 of February 2008, Pavel Machek wrote:
> Hi!

Hi,

> Are there any recent changes in cpu hotplug? I have suspend (random)
> problems, nosmp seems to fix it, and last messages in the "it hangs"
> case are from cpu hotplug...

I also have problems like this, investigating.

Please check if that started to trigger after the scheduler changes (you'd
need to go to commit b47711bfbcd4eb77ca61ef0162487b20e023ae55 IIRC).

Thanks,
Rafael
