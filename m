Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbYAKRRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbYAKRRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbYAKRRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:17:45 -0500
Received: from waste.org ([66.93.16.53]:40399 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759302AbYAKRRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:17:44 -0500
Subject: Re: [PATCH] Random number driver: make random_ioctl as an
	unlocked_ioctl function
From: Matt Mackall <mpm@selenic.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <1200051592.3844.63.camel@nikanth-laptop.blr.novell.com>
References: <1200051592.3844.63.camel@nikanth-laptop.blr.novell.com>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 11:17:08 -0600
Message-Id: <1200071828.3830.0.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 17:09 +0530, Nikanth Karthikesan wrote:
> The random_ioctl is registered as an ioctl function but it does not
> require BKL to be held when called. Changing it as an unlocked_ioctl
> function.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

Looks good, but I've already got this queued.

-- 
Mathematics is the supreme nostalgia of our time.

