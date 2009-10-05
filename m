Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZJEXys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZJEXys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbZJEXyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:54:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbZJEXyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:54:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: suspend tree build failure
Date: Tue, 6 Oct 2009 01:55:18 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091005160044.d95daf41.sfr@canb.auug.org.au>
In-Reply-To: <20091005160044.d95daf41.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910060155.18965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Stephen Rothwell wrote:
> Hi Rafael,

Hi,

> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> drivers/built-in.o: In function `.device_initialize':
> (.text+0x95cf4): undefined reference to `.device_pm_init'
> drivers/built-in.o: In function `.device_del':
> (.text+0x95ec4): undefined reference to `.device_pm_remove'
> drivers/built-in.o: In function `.device_add':
> (.text+0x965cc): undefined reference to `.device_pm_add'
> 
> Caused by commit 1db698d9d2c5a2f4032e620dd18c75b61eaca2c8 ("PM: Introduce
> PM links framework").  This build has CONFIG_PM not set.
> 
> I have used the suspend tree from next-20091002 for today.

Thanks for the notification, I've just pushed the updated tree where this
issue should be fixed.

Best,
Rafael
