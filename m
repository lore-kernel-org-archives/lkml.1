Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0CJGtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:49:55 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:35791 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0CJGtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:49:51 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/3] input: use input_mutex instead of BKL when opening input device
Date: Wed, 10 Mar 2010 07:49:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>,
       jkosina@suse.cz
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com> <20100309205947.GB1498@holoscopio.com> <20100310062015.GA2445@core.coreip.homeip.net>
In-Reply-To: <20100310062015.GA2445@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003100749.20723.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. März 2010 07:20:15 schrieb Dmitry Torokhov:
> > I was willing to let the open call go unprotected. But ended up checking
> > that the three callees were fine (they do not call any of the other
> > functions that take the mutex).
> > 
> > Since the fops_put/fops_get do protect that section from the handler
> > removal and I can't think of any other race right now, I think your
> > version is really better.
> > 
> > Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > 
> 
> OK, applied 2 Thadeu's patches and one Arnd's.

Jiri,

it is possible that this requires a change in usbhid as it uses BKL.
Do you remember?

	Regards
		Oliver
