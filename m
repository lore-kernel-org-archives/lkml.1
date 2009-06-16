Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbZFPPPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbZFPPPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZFPPP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:15:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZFPPPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:15:25 -0400
Date: Tue, 16 Jun 2009 11:15:24 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH 56/64] parisc: remove driver_data direct access of
	struct device
Message-ID: <20090616151524.GA15952@bombadil.infradead.org>
References: <20090616051351.GA23627@kroah.com> <1245131213-24168-56-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245131213-24168-56-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:46:45PM -0700, Greg Kroah-Hartman wrote:
> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
> 
> Cc: linux-parisc@vger.kernel.org
> Cc: Helge Deller <deller@gmx.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Kyle McMartin <kyle@mcmartin.ca>

Do you want to push it along with the rest of them, or would you like me
to apply it?

regards, Kyle
