Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZDVGJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZDVGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZDVGIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:08:54 -0400
Received: from kroah.org ([198.145.64.141]:37197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbZDVGIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:08:53 -0400
Date: Tue, 21 Apr 2009 22:51:18 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  usb/core/hub.c: fix sparse warnings
Message-ID: <20090422055118.GE9009@kroah.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DF9@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F8DF9@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 09:44:44PM -0400, H Hartley Sweeten wrote:
> Fix sparse warning in drivers/usb/core/hub.c.
> 
> 	warning: symbol 'temp' shadows an earlier one

Odd, I'm not seeing that when I run sparse on this file.  What version
of sparse are you using?

Also, the patch is line-wrapped and you delete a lot of trailing spaces.
Deleting trailing spaces is nice, but that's not what you said you were
doing here in this patch, so I'm going to have to drop it.

thanks,

greg k-h
