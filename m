Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZGAJDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZGAJDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZGAJC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:02:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58635 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZGAJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:02:55 -0400
Date: Tue, 30 Jun 2009 08:34:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tom Weissmann <tom.weissmann@gmail.com>
Cc: rubini@vision.unipv.it, linux-kernel@vger.kernel.org, jikos@suse.cz
Subject: Re: [PATCH] trackpoint: enable selection of press-to-select button
Message-ID: <20090630063437.GH1351@ucw.cz>
References: <6b1460640906250910x5ba98ce2wa990946486edfc0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b1460640906250910x5ba98ce2wa990946486edfc0d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu 2009-06-25 18:10:41, Tom Weissmann wrote:
> Currently the trackpoint driver supports press-to-select but only left
> button clicks can be generated, although the trackpoint itself can
> generate 3 different button clicks when pressed: left, middle, or
> right.
> 
> With this patch the trackpoint sysfs variable press-to-select can be
> set not only to 0 (off), 1 (left button), but also to 2 (middle
> button) and 3 (right button). This makes the feature more useful for
> left-handed users with no visible changes to the right-handed default
> behaviour.

Uhuh. Ugly as night. Could we instead convert press to button 4, and
let userland map it?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
