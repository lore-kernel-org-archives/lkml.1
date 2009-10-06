Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbZJFVlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbZJFVlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbZJFVls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:41:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177AbZJFVls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:41:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 32-rc2: runtime_pm is noisy
Date: Tue, 6 Oct 2009 23:42:20 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
References: <20091006080241.GB1362@ucw.cz>
In-Reply-To: <20091006080241.GB1362@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910062342.20910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Pavel Machek wrote:
> Hi!
> 
> Maybe it is my config,

Yes it is.

> but pm_runtime_idle is a bit too noisy on
> zaurus... ok, I do have pm_debug & pm_verbose

Exactly.

> set... but still, is it useful to print message about devices that do not
> support it?

It may be useful, because, for example, PCI can put devices without drivers
into low power states using this mechanism.

Still, perhaps we can drop the debug messages from __pm_runtime_idle().

Care to send a patch?

Rafael
