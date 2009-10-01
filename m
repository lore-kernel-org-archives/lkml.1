Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZJAIso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZJAIso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZJAIso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:48:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49279 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZJAIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:48:43 -0400
Date: Thu, 1 Oct 2009 10:48:45 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 31/34] move virtrng_remove to .devexit.text
Message-ID: <20091001084845.GC2181@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-31-git-send-email-u.kleine-koenig@pengutronix.de> <200910011044.48293.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200910011044.48293.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 10:44:48AM +0200, Christian Borntraeger wrote:
> Am Donnerstag 01 Oktober 2009 10:28:35 schrieb Uwe Kleine-König:
> > The function virtrng_remove is used only wrapped by __devexit_p so define
> > it using __devexit.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Thanks
 
> It seems that there are similar changes possible in other virtio drivers (e.g. 
> virtio_net). 
I think I once had a patch for that, but while updating the series it
was dropped.  I'll recheck for the next iteration.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
