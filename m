Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZL3Rw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZL3Rw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZL3Rw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:52:56 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44424 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZL3Rwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:52:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ij76X5DDbTkdNGGDjfpDJiYQL7do3amsGzGn/ejCshxPQJoCof1W+8++nJk+hDn2/K
         VZd8IAokUkgGZyYj4MwOW8cNyn+k2DGqunldsmPDELSuyVQpLGfesG//hsQiC3u7Pu2i
         tz3z9U7q5FsLWMUOXEqRBczNIo6MRTG+2nxdw=
Date: Wed, 30 Dec 2009 19:50:36 +0200
From: Dan Carpenter <error27@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] USB: serial: fix DMA buffers on stack for io_edgeport.c
Message-ID: <20091230175036.GB21362@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Johan Hovold <jhovold@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com> <20091230160645.GC29476@bicker> <20091230171457.GA15063@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230171457.GA15063@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 06:14:58PM +0100, Johan Hovold wrote:
> Hey Dan,
> 
> Looks like you forgot to free StringDesc:
> 

Gar...   That's embarrassing.  I'm really sorry about that.

I will send an updated patch tomorrow.

Also smatch sort of should have caught that with the --spammy option but
it didn't.  :/  In general the leak checks are pretty terrible.  Will 
look at this as well.

regards,
dan carpenter

