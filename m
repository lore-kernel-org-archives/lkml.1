Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbYFMDzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbYFMDzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 23:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYFMDzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 23:55:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:56104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbYFMDzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 23:55:44 -0400
Date: Thu, 12 Jun 2008 20:39:29 -0700
From: Greg KH <gregkh@suse.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: should use kobject_put() in kset-example
Message-ID: <20080613033929.GB17115@suse.de>
References: <4851E4DC.6040603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4851E4DC.6040603@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 11:09:16AM +0800, Li Zefan wrote:
> We should call kobject_put() instead of kfree() if kobject_init_and_add()
> returns an error, shouldn't we? Don't set up a bad example ;)

Ah, good catch, you are right.  I'll go add this to my queue, thanks for
the patch.

greg k-h
