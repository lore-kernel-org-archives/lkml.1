Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbZJISca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbZJISca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761344AbZJISc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:32:29 -0400
Received: from kroah.org ([198.145.64.141]:35321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761274AbZJISbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:31:41 -0400
Date: Fri, 9 Oct 2009 10:25:35 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -repost 1/1] USB: usblcd, fix memory leak
Message-ID: <20091009172535.GA4850@kroah.com>
References: <1255097428-24250-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255097428-24250-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 04:10:28PM +0200, Jiri Slaby wrote:
> Stanse found a memory leak in lcd_probe. Instead of returning without
> releasing the memory, jump to the error label which frees it.
> 
> http://stanse.fi.muni.cz/
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Sorry for the delay, just now picked up your original patch.

thanks,

greg "my inbox sucks" k-h
