Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZDFFog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZDFFog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZDFFo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:44:26 -0400
Received: from kroah.org ([198.145.64.141]:47437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751625AbZDFFo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:44:26 -0400
Date: Sun, 5 Apr 2009 22:29:32 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] Staging: serqt_usb: switch to proc_fops
Message-ID: <20090406052932.GA19096@kroah.com>
References: <20090405003748.GA26458@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090405003748.GA26458@orion>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 04:37:48AM +0400, Alexander Beregalov wrote:
> Fix this build error:
> serqt_usb.c:441: error: unknown field 'read_proc' specified in initializer
> 
> tty_operations::read_proc was removed in 0f043a81e
> (proc tty: remove struct tty_operations::read_proc)
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Thanks for the patch, but I just deleted this function completely, as
it's not needed at all.  The driver needs to be converted to use the
usb-serial layer, not duplicate it, incorrectly, as it currently has
done.  I'm still working on it, that's why it's in the staging tree :)

thanks again,

greg k-h
