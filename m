Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbXHOOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbXHOOzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761648AbXHOOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:54:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60623 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763370AbXHOOyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kMYYwpdzjia1Mstr+ydwzSbw3DqVDELnBB9jhDrFb05WEFcOKzLM9sprNU6hSutA2z2ijCWGJzCD2g2gB+0kIURy6e7qWLIgeRna7R5vL+hqjgAZsidTK5Wsc4u449x376NMGwjx/MJ1okHm6/6J63L2Wj8VwaDPNg9z5qQgeu0=
Message-ID: <46C313B3.4030700@gmail.com>
Date: Wed, 15 Aug 2007 23:54:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Florin Iucha <florin@iucha.net>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
References: <Pine.LNX.4.44L0.0708151033270.3895-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708151033270.3895-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> I think we can simply remove the error message.  There's no obvious 
> reason why sysfs_remove_bin_file() should complain about attempts to 
> remove a nonexistent file; sysfs_remove_file() doesn't.
> 
> This patch will get rid of the annoying error messages.  It won't do 
> anything about your keyboard's tendency to spontaneously stop working, 
> alas.

Agreed but I think sysfs_remove_bin_file() should relay the return value
from sysfs_has_and_remove() to the caller.

Thanks.

-- 
tejun
