Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZEKR7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZEKR7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZEKR7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:59:40 -0400
Received: from kroah.org ([198.145.64.141]:47779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZEKR7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:59:39 -0400
Date: Mon, 11 May 2009 10:56:26 -0700
From: Greg KH <greg@kroah.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511175626.GA4758@kroah.com>
References: <20090509143742.GA27663@kroah.com> <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 01:40:30PM -0400, David P. Quigley wrote:
> I took the patches and applied them to Linus' tree and installed the
> kernel on a Fedora 10 box with SELinux enabled and it oopses on startup.
> The oops happens every time I boot up so I can reproduce it as needed to
> help fix it. I've attached my kernel config in case that helps and have
> pasted the oops below. If needed I can provide the entire dmesg output.

If you disable selinux at the boot command line, does this oops not
happen?

thanks for testing and reporting this,

greg k-h
