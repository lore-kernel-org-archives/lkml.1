Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYEMWCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYEMWCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbYEMWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:02:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57969 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584AbYEMWCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:02:09 -0400
Date: Tue, 13 May 2008 15:01:03 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] struct class sem to mutex converting
Message-ID: <20080513220103.GA7599@kroah.com>
References: <20080509072231.GB2740@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509072231.GB2740@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 03:22:31PM +0800, Dave Young wrote:
> The class_device is already removed, so do the class->sem to mutex converting.

Are you sure this will work?  Have you tried running lockdep to verify
that there are no problems here?  People have tried this in the past
with devices and I don't think it will work here either :(

thanks,

greg k-h
