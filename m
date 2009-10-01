Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZJARos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZJARos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZJARor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:44:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58000 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbZJARor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:44:47 -0400
Date: Thu, 1 Oct 2009 19:44:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 07/34] move ilo_remove to .devexit.text
Message-ID: <20091001174449.GB27288@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-7-git-send-email-u.kleine-koenig@pengutronix.de> <92D64232F2316045B18937D5C9996B1522CD82DF6E@GVW1144EXB.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92D64232F2316045B18937D5C9996B1522CD82DF6E@GVW1144EXB.americas.hpqcorp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Thu, Oct 01, 2009 at 02:10:27PM +0000, Altobelli, David wrote:
> > The function ilo_remove is used only wrapped by __devexit_p so define it
> > using __devexit.
> 
> Looks good to me.  Not sure if this is needed or not...
it fixes at least a warning if you compile the driver as built-in with
CONFIG_HOTPLUG=n about ilo_remove not being used.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
