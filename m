Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZBDB3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZBDB3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBDB2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:28:45 -0500
Received: from kroah.org ([198.145.64.141]:47816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751485AbZBDB2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:28:44 -0500
Date: Tue, 3 Feb 2009 17:16:40 -0800
From: Greg KH <greg@kroah.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2 RESEND] platform: introduce module id table for
	platform devices
Message-ID: <20090204011640.GC17622@kroah.com>
References: <498464ED.3010607@gmail.com> <20090131155147.GU12431@fluff.org.uk> <f17812d70902020211u63d7e510k81926f45ff672323@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70902020211u63d7e510k81926f45ff672323@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 06:11:48PM +0800, Eric Miao wrote:
> >
> > surely you mean PLATFORM_NAME_SIZE in this struct?
> 
> Indeed, patch updated below (and as attached):

With this patch, I get the following warning:
	drivers/base/platform.c:598: warning: assignment discards qualifiers from pointer target type

Also, don't put platform_match_id() underneath the comments for
platform_match(), that will only confuse the kernel-doc scripts and any
developer looking at the code.

Care to fix it up and resend?

thanks,

greg k-h
