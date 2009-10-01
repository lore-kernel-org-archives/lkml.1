Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZJAJPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZJAJPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZJAJPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:15:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbZJAJPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:15:13 -0400
Date: Thu, 1 Oct 2009 11:12:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 31/34] move virtrng_remove to .devexit.text
Message-ID: <20091001091218.GE5718@redhat.com>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-31-git-send-email-u.kleine-koenig@pengutronix.de> <200910011044.48293.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200910011044.48293.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

FWIW
Acked-by: Michael S. Tsirkin <mst@redhat.com>

> It seems that there are similar changes possible in other virtio drivers (e.g. 
> virtio_net). 

Yes, and more importantly drivers/virtio/virtio.c as well.

> 
> [...]
> > -static void virtrng_remove(struct virtio_device *vdev)
> > +static void __devexit virtrng_remove(struct virtio_device *vdev)
> [...]
