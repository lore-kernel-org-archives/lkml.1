Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZJAIor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZJAIor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZJAIor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:44:47 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:58901 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZJAIoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:44:46 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 31/34] move virtrng_remove to .devexit.text
Date: Thu, 1 Oct 2009 10:44:48 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-prerelease; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>
References: <20091001082607.GA2181@pengutronix.de>  <1254385718-14254-31-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1254385718-14254-31-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910011044.48293.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 01 Oktober 2009 10:28:35 schrieb Uwe Kleine-König:
> The function virtrng_remove is used only wrapped by __devexit_p so define
> it using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

It seems that there are similar changes possible in other virtio drivers (e.g. 
virtio_net). 


[...]
> -static void virtrng_remove(struct virtio_device *vdev)
> +static void __devexit virtrng_remove(struct virtio_device *vdev)
[...]
