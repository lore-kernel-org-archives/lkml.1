Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZGUPKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZGUPKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZGUPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:10:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41418 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752679AbZGUPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:10:29 -0400
Date: Tue, 21 Jul 2009 16:10:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
Message-ID: <20090721161023.7607ea7f@lxorguk.ukuu.org.uk>
In-Reply-To: <200907211700.21059.arnd@arndb.de>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com>
	<200907211324.26617.arnd@arndb.de>
	<20090721131026.12107411@lxorguk.ukuu.org.uk>
	<200907211700.21059.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. built-in code adds platform-device for mrst_ipc
> 2. user space auto-loads the mrst_ipc driver
> 3. mrst_ipc driver creates child devices for each of its attached
>    devices

The devices talking to it already are devices - but they will be input
devices, watchdogs, etc. They already belong in existing classes.

I also don't believe the mrst ipc is enumerable either. If it was
enumerable it would make a lot more sense.

Having the mrst a platform device which itself contains the hardcoded
magic addresses definitely sounds a good move.
