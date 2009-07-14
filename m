Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZGOOyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZGOOyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZGOOyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:54:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52839 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbZGOOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:54:13 -0400
Date: Wed, 15 Jul 2009 01:53:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090714235332.GA1552@ucw.cz>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-14 15:11:45, Luis R. Rodriguez wrote:
> I'm working on Wake-on-Wireless support for wireless right now [1].
> Upon wake up I wanted to inform the kernel of the event which caused
> the wake up but am not clear if there is a generic API for this. Mind
> you, for WoW we'll need at least some AC power to the card so we'll
> need to at least be in S3-Hot so we'll only need events for that for
> now.
> 
> Do we have some generic infrastructure to gather reasons for wake up
> from S1-S4 and pass this to userspace yet?

I do not think generic api exists...

How does it work? I thought that wifi stack is in software -> you need
main cpu to run for wifi to work?

...and what are the applications? I understand that WoL is useful for
remote administration of connected desktops.
								Pavel

> [1] http://wireless.kernel.org/en/users/Documentation/WoW


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
