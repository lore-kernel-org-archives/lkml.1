Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbZLVK7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbZLVK7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZLVK7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:59:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1377 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZLVK7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:59:13 -0500
Subject: Re: [PATCH] MAINTAINERS: Fix entry for uwb to include
 subdirectories
From: Joe Perches <joe@perches.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: David Vrabel <david.vrabel@csr.com>, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200912221130.30586.PeterHuewe@gmx.de>
References: <1261472760-24854-1-git-send-email-peterhuewe@gmx.de>
	 <1261473735.1895.22.camel@Joe-Laptop.home>
	 <200912221130.30586.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 02:59:11 -0800
Message-ID: <1261479551.1895.43.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 11:30 +0100, Peter Hüwe wrote:
> Okay I guess it IS correct

Maybe it is.

David Vrabel should be able to ack/nack it.

By default, get_maintainer checks a 1 year history
for commits.  If a file hasn't had a modification
in over a year, it likely isn't maintained, it's
already perfect or it's obsolete.

You could change the get_maintainer history window
with --git-since=date

Anyway, if get_maintainer doesn't give you a result,
look at the git log for the file or look inside the
source code of the file itself.

Here's the _only_ commit for that file:

$ git log drivers/uwb/i1480/i1480-est.c
commit 1ba47da527121ff704f4e9f27a12c9f32db05022
Author: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Date:   Wed Sep 17 16:34:20 2008 +0100

    uwb: add the i1480 DFU driver
    
    Add the driver for downloading the firmware to an Intel i1480 device.
    
    Signed-off-by: David Vrabel <david.vrabel@csr.com>

And in the file:

 * Copyright (C) 2005-2006 Intel Corporation
 * Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

So you should add Inaky to your patch cc list.

cheers, Joe

