Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab0CJSLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:11:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1609 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab0CJSLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:11:51 -0500
Subject: Re: smatch_scripts/whitespace_only.sh
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, kernel-janitors@vger.kernel.org,
       devel@driverdev.osuosl.org
In-Reply-To: <Pine.LNX.4.64.1003101537040.27249@ask.diku.dk>
References: <20100310101224.GC6321@bicker>
	 <Pine.LNX.4.64.1003101113330.24684@ask.diku.dk>
	 <20100310142759.GG6321@bicker>
	 <Pine.LNX.4.64.1003101537040.27249@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 10:11:49 -0800
Message-ID: <1268244709.1545.392.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 15:38 +0100, Julia Lawall wrote:
> > > On Wed, 10 Mar 2010, Dan Carpenter wrote:
> > > > I wrote a script to check that a patch only changes white space.

Perhaps you could use #define __LINE__ 0 to avoid
any vertical line position comparison checks?

> Maybe checkpatch could be changed to not complain about > 80 characters 
> when the line contains a string?

That's been at least partially done in commit
691e669ba8c64d31ac08d87b1751e6acfa3ff65e


