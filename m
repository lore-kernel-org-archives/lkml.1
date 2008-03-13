Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYCMUro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYCMUro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYCMUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:47:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50280 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYCMUrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:47:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Thu, 13 Mar 2008 21:46:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706300859.47133.arvidjaar@mail.ru> <200711212047.13464.rjw@sisk.pl> <200803130708.56282.arvidjaar@mail.ru>
In-Reply-To: <200803130708.56282.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132146.42156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of March 2008, Andrey Borzenkov wrote:
> 
> For the record - it happened again under 2.6.25-rc5; it reall drives
> me nuts. Of course every time it happens I do not have infrastructure to use
> netconsole :( I am about to reformat the whole with ext3 as this seems
> to always hang somewhere in fs access and looks like not many people
> use reiser today.
>

Well, it may be related to having the root partition on reiserfs.  I've never
seen anything like this with non-root reiserfs partitions ...

Thanks,
Rafael
