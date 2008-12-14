Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYLNTNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYLNTNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 14:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYLNTNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 14:13:43 -0500
Received: from kroah.org ([198.145.64.141]:38727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751241AbYLNTNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 14:13:43 -0500
Date: Sun, 14 Dec 2008 11:12:33 -0800
From: Greg KH <greg@kroah.com>
To: Coly Li <coly.li@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid unnecessary assignment in lookup_bdev()
Message-ID: <20081214191233.GB31396@kroah.com>
References: <49455170.6080307@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49455170.6080307@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 02:33:20AM +0800, Coly Li wrote:
> In normal cases, lookup_bdev() should return successfully, therefore it's not a good idea to always
> assign error values before checking truth/false conditions. This patch modifies code to only assign
> error value in necessary false conditions.
> 
> If I missed something, please correct me.

I don't understand, is there some way that the current code could
incorrectly return an error value?

Is your change somehow faster?  I don't think this is on any fast-path
code, right?

thanks,

greg k-h
