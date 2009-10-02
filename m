Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZJBTNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZJBTNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZJBTNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:13:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49031 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZJBTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:13:22 -0400
Date: Fri, 2 Oct 2009 21:13:17 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@redhat.com>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/34] move atp870u_remove to .devexit.text
Message-ID: <20091002191317.GA17428@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-2-git-send-email-u.kleine-koenig@pengutronix.de> <1254406802.3885.1.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1254406802.3885.1.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 01, 2009 at 02:20:02PM +0000, James Bottomley wrote:
> Given that practically every kernel on the planet is hotplug enabled
> these days and that the savings on the very few that aren't from
> discarding the devexit section is at most a page or two (and even arm
> says they don't care about that), there doesn't seem to be any point
> making these changes.  In fact, I think we can just kill devinit and
> devexit as section markers.
IMHO you should better kill CONFIG_HOTPLUG completely then.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
