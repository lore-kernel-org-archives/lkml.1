Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbZFQCzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbZFQCzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZFQCzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:55:38 -0400
Received: from kroah.org ([198.145.64.141]:39897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZFQCzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:55:37 -0400
Date: Tue, 16 Jun 2009 19:51:34 -0700
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] driver/core: Fix various warnings due to
	dev_set_name() usage
Message-ID: <20090617025134.GA6807@kroah.com>
References: <1245203150.21602.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245203150.21602.10.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 11:45:50AM +1000, Benjamin Herrenschmidt wrote:
> gcc is too smart, we get:
> 
> drivers/base/core.c: In function ‘device_add’:
> drivers/base/core.c:877: warning: format not a string literal and no format arguments
> drivers/base/core.c: In function ‘__root_device_register’:
> drivers/base/core.c:1274: warning: format not a string literal and no format arguments
> 
> With 4.3.3 and later. This fixes a bunch of them in drivers/base

These have all been fixed in linux-next for a while, and are already
contained in the patchset I sent to Linus for inclusion in his tree
yesterday.

But thanks anyway :)

greg k-h
