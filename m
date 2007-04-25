Return-Path: <linux-kernel-owner+w=401wt.eu-S2992787AbXDYOEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992787AbXDYOEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992786AbXDYOEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:04:05 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:36703
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992787AbXDYOEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:04:04 -0400
Date: Wed, 25 Apr 2007 16:06:59 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in RocketPort driver v2
Message-ID: <20070425140659.GN6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
References: <20070425130843.GK6798@traven> <462F5D9C.9050706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462F5D9C.9050706@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Apr 25, 2007 at 03:54:36PM +0200 Jiri Slaby ha dit:

> Matthias Kaehlcke napsal(a):
> > the RocketPort driver uses a semaphore as mutex. use the mutex API
> > instead of the (binary) semaphore
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> > 
> 
> I think that ERESTARTSYS is appropriate here.

thanks for your remark, i'll take it into account

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

            Nothing is more despicable than respect based on fear
                              (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
