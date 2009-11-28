Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZK1TLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZK1TLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 14:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZK1TLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 14:11:22 -0500
Received: from kroah.org ([198.145.64.141]:48005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbZK1TLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 14:11:21 -0500
Date: Sat, 28 Nov 2009 10:58:46 -0800
From: Greg KH <greg@kroah.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: Brian Swetland <swetland@google.com>,
       Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] staging/android fixes
Message-ID: <20091128185846.GA23662@kroah.com>
References: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 09:45:13AM +0100, Corentin Chary wrote:
> Hi,
> Here is a patch to fix build for android specifics drivers.
> 
> What we should do next to prevent them from being removed in 2.6.23 ?

Provide _real_ forward progress on the code.  Google has not contributed
anything, and neither has anyone else, becides various tiny fixups, like
the low-memory one that you just did.

> Is there any chance that all android stuff would be merged one day ?

That is up to the developers of the code.  I would hope that it would,
but it needs a _lot_ of work to get there.

So for now, unless you are willing to maintain this code and work to get
it merged into the main kernel tree (which will require changes to the
kernel/userspace apis in a number of places, which will require buy-in
by the owners of that userspace code), I'm going to have to drop the
code.

sorry,

greg k-h
