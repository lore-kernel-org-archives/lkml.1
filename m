Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbZJ0VQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbZJ0VQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932391AbZJ0VQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:16:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40858 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbZJ0VQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:16:15 -0400
Date: Tue, 27 Oct 2009 17:05:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Staging: netwave: move driver to staging
Message-ID: <20091027210554.GG15566@tuxdriver.com>
References: <1256015830-12700-4-git-send-email-linville@tuxdriver.com> <20091027203643.GA28719@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027203643.GA28719@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 01:36:43PM -0700, Greg KH wrote:
> On Tue, Oct 20, 2009 at 02:17:10PM +0900, John W. Linville wrote:
> > -menuconfig WLAN_80211
> 
> If you are removing this config option, what should we use to depend on
> the wireless stack?  This is what the staging wireless drivers use,
> should they be changed to use something else?

Hmmm...probably WLAN will do.  I should probably make that depend on NETDEVICES as well...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
