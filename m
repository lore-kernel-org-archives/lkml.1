Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYAUKaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYAUKaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbYAUK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:29:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:34672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758453AbYAUK3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:29:54 -0500
From: Andreas Schwab <schwab@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Use separate sections for __dev/__cpu/__mem code/data
References: <20080120200527.GA23852@uranus.ravnborg.org>
	<1200859743-24037-1-git-send-email-sam@ravnborg.org>
	<1200859743-24037-2-git-send-email-sam@ravnborg.org>
	<1200859743-24037-3-git-send-email-sam@ravnborg.org>
	<1200859743-24037-4-git-send-email-sam@ravnborg.org>
	<1200859743-24037-5-git-send-email-sam@ravnborg.org>
	<1200859743-24037-6-git-send-email-sam@ravnborg.org>
	<1200859743-24037-7-git-send-email-sam@ravnborg.org>
	<1200859743-24037-8-git-send-email-sam@ravnborg.org>
	<20080121073341.GA20050@linux-sh.org>
	<20080121095722.GA29145@uranus.ravnborg.org>
X-Yow: Yow!!  It's LIBERACE and TUESDAY WELD!!  High on a HILL... driving a
 LITTLE CAR...  I wanna be in that LITTLE CAR, too!!  I wanna drive off
 with LIBBY and TUESDAY!
Date: Mon, 21 Jan 2008 11:29:52 +0100
In-Reply-To: <20080121095722.GA29145@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Mon\, 21 Jan 2008 10\:57\:22 +0100")
Message-ID: <jebq7fqxnj.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

> On Mon, Jan 21, 2008 at 04:33:41PM +0900, Paul Mundt wrote:
>> so the ## is being taken directly rather than acting as a concatenation.
>
> Strange...
> I can reproduce with gcc 3.4.5 here - will fix.

The ## operator does not work with -traditional.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
