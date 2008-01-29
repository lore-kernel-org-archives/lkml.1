Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYA2V4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYA2V4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbYA2V4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:56:31 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46729 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759855AbYA2V4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:56:30 -0500
Date: Tue, 29 Jan 2008 22:56:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: sections mismatches: How to mark new false positives?
Message-ID: <20080129215632.GA15644@uranus.ravnborg.org>
References: <20080129170255.GP8767@does.not.exist> <20080129181305.GB14056@uranus.ravnborg.org> <20080129190046.GR8767@does.not.exist> <20080129194920.GC14056@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129194920.GC14056@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I would suggest the following fix.

Looked a bit closer.
We have more warnings in this area and I see
code where we previously remove the __devinit
annotation.

It looks like we should take all the HOTPLUG only
functions from probe.c and move them elsewhere
(hotplug.c or probe_hotplug.c) and then
only build this file if HOTPLUG is enabled.

This seems like a straightforward solution.
If no-one beats me I will look into that in the weekend.

	Sam
