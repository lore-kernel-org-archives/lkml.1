Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZJ0Ujh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZJ0Ujh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932150AbZJ0Ujg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:39:36 -0400
Received: from kroah.org ([198.145.64.141]:52573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbZJ0Ujf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:39:35 -0400
Date: Tue, 27 Oct 2009 13:36:43 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Staging: netwave: move driver to staging
Message-ID: <20091027203643.GA28719@kroah.com>
References: <1256015830-12700-4-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256015830-12700-4-git-send-email-linville@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 02:17:10PM +0900, John W. Linville wrote:
> -menuconfig WLAN_80211

If you are removing this config option, what should we use to depend on
the wireless stack?  This is what the staging wireless drivers use,
should they be changed to use something else?

thanks,

greg k-h
