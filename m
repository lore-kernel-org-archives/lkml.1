Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbZDOJMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbZDOJMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZDOJMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:12:30 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:59256
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbZDOJM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:12:29 -0400
Date: Wed, 15 Apr 2009 11:12:23 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Bill Gatliff <bgat@billgatliff.com>
Subject: Re: Linux 2.6.30-rc2: [PATCH] ARM OABI compatibility: fix build
	error
Message-ID: <20090415091223.GB12921@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Bill Gatliff <bgat@billgatliff.com>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain> <20090415083326.GA12921@traven> <20090415090307.GH6058@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415090307.GH6058@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Apr 15, 2009 at 10:03:07AM +0100 Russell King - ARM Linux ha dit:

> On Wed, Apr 15, 2009 at 10:33:26AM +0200, Matthias Kaehlcke wrote:
> > Building for ARM with CONFIG_OABI_COMPAT enabled fails due to a
> > missing include:
> 
> Yes, lots of people have been whinging about this over the last six days,
> but I'm only just catching up since returning from an Easter break.
> 
> Does anyone know /when/ this breakage happened, or even better what caused
> it?

a week ago i build v2.6.30-rc1 based on the same .config without
running into this issue. if i find some time i'll try bisecting it

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
