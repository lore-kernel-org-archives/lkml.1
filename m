Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZJWQKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZJWQKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZJWQKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:10:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51067 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZJWQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:10:09 -0400
Date: Fri, 23 Oct 2009 18:10:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091023161006.GA1580@ucw.cz>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-20 14:17:07, John W. Linville wrote:
> Move the strip ("Starmode Radio IP") driver to drivers/staging.  For
> several years this driver has only seen API "bombing-run" changes, and
> few people ever had the hardware.  This driver represents unnecessary
> ongoing maintenance for no clear benefit.

This seems like abuse of the staging process.

There's no TODO to say what needs to be fixed. You just don't want to
maintain it. Because there's nothing to fix, noone has reason to patch
it, and the (working, good enough) driver will just be removed.

It also marks driver as broken when it is not...

What about removing it in the regular way, that's
Documentation/feature-removal.txt ?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
