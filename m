Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYKBRyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYKBRyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 12:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYKBRy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 12:54:28 -0500
Received: from kroah.org ([198.145.64.141]:45478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753875AbYKBRy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 12:54:27 -0500
Date: Sun, 2 Nov 2008 07:37:53 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Subbu Seetharaman <subbus@serverengines.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] benet: BladeEngine 10Gb NIC driver
Message-ID: <20081102153753.GA21617@kroah.com>
References: <20080916090021.c4a58c42@mailhost.serverengines.com> <490DA7E3.8040802@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490DA7E3.8040802@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 08:15:15AM -0500, Jeff Garzik wrote:
> Subbu Seetharaman wrote:
>> Jeff,
>> It is more than two months since the benet driver patch was made available 
>> as a single file as suggeted by you :
>> ftp://ftp.serverengines.com/0001.benet.patch
>> I have not seen this applied.  Is there any reason for not applying this  
>> patch ?  Do you want a patch against the latest git tree ?
>
> The overall consensus at this year's Linux Kernel Summit was that this 
> driver still needs a lot of cleanup, so I'm gonna try an experiment and 
> stick this in the staging tree (currently jgarzik/netdev-2.6.git#benet).
>
> Greg, do I need to do anything beyond simply putting it into the directory? 
>  Do I need to add some code to taint, perhaps?

Anything in the drivers/staging/ directory tree will automatically get
the TAINT_CRAP flag applied to it, so there should not be any need to do
anything else for this.

But, if you want, I can take this, to handle any Kconfig and Makefile
merges that are probably going to be necessary do to me also adding new
drivers in my staging tree.  If so, feel free to send me the patch.

thanks,

greg k-h
