Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbZHEQRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbZHEQRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933979AbZHEQRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:17:49 -0400
Received: from kroah.org ([198.145.64.141]:47828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbZHEQRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:17:48 -0400
Date: Wed, 5 Aug 2009 09:16:43 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
Message-ID: <20090805161643.GA28436@kroah.com>
References: <4A79283E.7030202@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A79283E.7030202@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 03:35:42PM +0900, Tejun Heo wrote:
> [un]register_chrdev() assume minor range 0-255.  This patch adds __
> prefixed versions which take @minorbase and @count explicitly.

What's the difference between this and the existing
register_chrdev_region() function?  Why doesn't that work for you?

What am I missing here?

thanks,

greg k-h
