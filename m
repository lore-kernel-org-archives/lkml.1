Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZALNvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZALNvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZALNu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:50:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49528 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZALNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:50:58 -0500
Date: Mon, 12 Jan 2009 14:50:57 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Subject: wrong usage of __devexit_p and __exit_p
Message-ID: <20090112135057.GA10250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found several drivers that use __devexit_p and __exit_p on functions
that don't live in .devexit.text or .exit.text resp.

The impact is either that these functions use memory without being used
or that they don't link.

I send 24 patches as a reply to this mail.  I choosed to move the
functions into the respective function instead of using the right
__{dev,}exit_p wrapper because it seems to me to have less impact.

I didn't made the effort to find out the right people to Cc: but I hope
that Andrew takes care of that :-)

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
