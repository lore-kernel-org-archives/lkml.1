Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbZKQOP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbZKQOP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZKQOP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:15:27 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57761 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZKQOP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:15:26 -0500
Date: Tue, 17 Nov 2009 09:05:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Renzmann <mrenzmann@madwifi-project.org>,
       madwifi-devel@lists.sourceforge.net,
       madwifi-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and
	why?
Message-ID: <20091117140534.GD27743@tuxdriver.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de> <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 05:01:09PM -0800, Luis R. Rodriguez wrote:

> If a few developers still exist who are committed to helping maintain
> madwifi until ath5k gets feature-parred the easiest solution now
> (since the HAL is open) is to just throw it into staging and hopefully
> that'll attract more developers to help keep it up to date with actual
> current kernels.

For the record, I would be generally opposed to adding madwifi to
drivers/staging.  We already have enough trouble with duplication of
hardware support between drivers/staging and drivers/net/wireless.

If madwifi has features that people need/want and that ath5k/mac80211
still lacks, lets talk about how to get them (or reasonabe replacements
for them) into the mainline kernel.  I'm sure some ideas will meet
some resistance, but if someone is motivated to continue pursuing
maintenance of madwifi than they should be motivated enough to at
least try to convince the rest of us why those features are worth
having in net/wireless, net/mac80211, and/or drivers/net/wireless.
Even if the solution is some quirky thing that "normal" people will
ignore, it is bound to be better to have mainline support than to
continue working out-of-tree.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
