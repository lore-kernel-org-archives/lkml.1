Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZGMCLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZGMCLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 22:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZGMCLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 22:11:09 -0400
Received: from kroah.org ([198.145.64.141]:35943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZGMCLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 22:11:07 -0400
Date: Sun, 12 Jul 2009 19:10:34 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: usb.current tree build warnings
Message-ID: <20090713021034.GA19267@kroah.com>
References: <20090713113826.073e7bb4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713113826.073e7bb4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 11:38:26AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/usb/serial/option.c: In function 'option_instat_callback':
> drivers/usb/serial/option.c:834: warning: unused variable 'serial'
> drivers/usb/serial/option.c: In function 'option_open':
> drivers/usb/serial/option.c:930: warning: unused variable 'serial'
> 
> Introduced by commit d9860b9ea060492b9ce239c6317f65db1d96ffb9 ("USB:
> option: remove unnecessary and erroneous code").

Hm, I thought I had fixed that up in a later patch.  But you are right,
it should be addressed in this patch, I'll look at it tomorrow morning.

thanks,

greg k-h
