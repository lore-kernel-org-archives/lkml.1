Return-Path: <linux-kernel-owner+w=401wt.eu-S933474AbXBEV26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474AbXBEV26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933476AbXBEV26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:28:58 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:49088 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474AbXBEV2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:28:53 -0500
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070203003536.GA619@khazad-dum.debian.net>
References: <20070202235132.EDBDF1C448@hermes.mvista.com>
	 <20070202161611.cf8b4328.akpm@linux-foundation.org>
	 <20070203003536.GA619@khazad-dum.debian.net>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 08:28:33 +1100
Message-Id: <1170710913.6105.39.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-02-02 at 22:35 -0200, Henrique de Moraes Holschuh wrote:
> On Fri, 02 Feb 2007, Andrew Morton wrote:
> > Well the code appears simple enough, but I've not previously heard anyone
> > express a need for this feature.  But I know how to cc people who might
> > have heard this.
> 
> You are, now.
> 
> We usually try to do it in userspace (and it gets ugly when we fail).  If
> the kernel would do it, it would be very welcome.

Why do you think remounting filesystems is necessary? Are you getting
problems with some particular filesystem?

If I recall correctly, we briefly tried remounting filesystems in
Suspend2, but it created problems with logging - some files open r/w
were readonly afterwards. We then tried bdev freezing with much better
success.

Regards,

Nigel

