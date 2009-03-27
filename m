Return-Path: <linux-kernel-owner+w=401wt.eu-S1765181AbZC0XyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765181AbZC0XyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763335AbZC0Xtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:49:32 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:58514 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764021AbZC0Xtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:49:31 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net D7A13332790
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [patch] char/raw.c locking on error
To: Jonathan Corbet <corbet@lwn.net>, Michael Tokarev <mjt@tls.msk.ru>,
       Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       eteo@redhat.com
Reply-To: 7eggert@gmx.de
Date: Sat, 28 Mar 2009 00:49:27 +0100
References: <ckhDP-7Ey-1@gated-at.bofh.it> <ckmtX-6ZA-25@gated-at.bofh.it> <ckrWP-7iQ-33@gated-at.bofh.it> <cks6g-7wu-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LnLnk-0002B1-5Y@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:

>> Is it still in use - the raw driver, that is?  Nowadays,
>> every block device can be opened in direct mode by using
>> O_DIRECT - this is what raw does.  I mean, is it worth
>> spending even more time on it?

As long as you don't fix all the legacy applications to use O_DIRECT.

> This was discussed a while back.  My understanding is that there are
> people using it.  It is a user-space ABI of sorts which can't just be
> yanked arbitrarily.  The right thing to do is probably to replace it
> with a shell implementation that just opens the device using O_DIRECT,
> but nobody has actually done that...

It had long been done when before it was discussed the last time.

