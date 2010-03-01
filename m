Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0CAUAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:00:45 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44992 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0CAUAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:00:42 -0500
Date: Mon, 1 Mar 2010 14:57:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 802.11 development process - extended documentation
Message-ID: <20100301195756.GF2961@tuxdriver.com>
References: <43e72e891002241618w10d5c45ar9303f074d0228217@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e891002241618w10d5c45ar9303f074d0228217@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 04:18:08PM -0800, Luis R. Rodriguez wrote:
> I've extended our 802.11 development process into a new section on our
> 802.11 wiki. I often get asked how this works from different parts of
> the company here at Atheros so figured it'd be easier to illustrate
> this as best as possible and share it.
> 
> http://wireless.kernel.org/en/developers/process
> 
> Hope it does justice, John if you see any mistakes feel free to edit.
> If the diagram seems fishy let me know what I can fix.

Overall, looks good.  I would make these changes to the diagram:

	-- remove wireless-testing -> wireless-next-2.6 arrow

	-- add me -> wireless-next-2.6 arrow

	-- add wireless-2.6 -> wireless-testing arrow

	-- add wireless-next-2.6 -> wireless-testing arrow

This would reflect that patches go into wireless-2.6 and
wireless-next-2.6, then are pulled to wireless-testing.  A few patches
may go to wireless-testing directly, but they will eventually be
reverted and possibly replaced with a patch in one of the other trees
(and subsequently pulled back into wireless-testing).  Nothing pulls
from wireless-testing (except developers).

Thanks for the doc! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
