Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZC0VgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZC0VgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZC0VgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:36:14 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:52649 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZC0VgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:36:14 -0400
Message-ID: <49CD46C8.8040606@msgid.tls.msk.ru>
Date: Sat, 28 Mar 2009 00:36:08 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       eteo@redhat.com
Subject: Re: [patch] char/raw.c locking on error
References: <Pine.LNX.4.64.0903262243150.4167@usbsys.site> <20090327094812.32d0d5e7@bike.lwn.net>
In-Reply-To: <20090327094812.32d0d5e7@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> (I bet raw doesn't need BKL at all; I'll see if I can't find some time
> to have a look later on).

Is it still in use - the raw driver, that is?  Nowadays,
every block device can be opened in direct mode by using
O_DIRECT - this is what raw does.  I mean, is it worth
spending even more time on it?

/mjt
