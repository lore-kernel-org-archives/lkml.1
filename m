Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXIFL1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXIFL1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXIFL1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:27:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:57099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbXIFL1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:27:43 -0400
To: rct@gherkin.frus.com (Bob Tracy)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc5 panics
References: <20070906052434.B7420DBA2@gherkin.frus.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Sep 2007 13:27:42 +0200
In-Reply-To: <20070906052434.B7420DBA2@gherkin.frus.com>
Message-ID: <p73zm009gpd.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rct@gherkin.frus.com (Bob Tracy) writes:

> This may be the most worthless bug report ever filed, but maybe someone
> else is seeing this that can shed some light on the matter.  Everything
> was rock-solid with -rc3, but I've had two panics with -rc5 in as many
> days.  The first occurred within five minutes of booting.  The second
> was after nearly 48 hours of uptime.  Nothing is getting written to
> syslog, and the second panic happened while X11 was active, so I didn't
> even get so much as a stack dump on the console -- just the flashing
> keyboard leds that signaled entry into "brick emulation" mode :-(.

If you have a second machine on the network could you perhaps
set up netconsole (see Documentation/networking/netconsole.txt) and see
if it catches something?

-Andi
