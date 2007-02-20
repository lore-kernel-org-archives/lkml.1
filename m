Return-Path: <linux-kernel-owner+w=401wt.eu-S1030386AbXBTVTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030386AbXBTVTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030428AbXBTVTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:19:01 -0500
Received: from smtp106.sbc.mail.re2.yahoo.com ([68.142.229.99]:39743 "HELO
	smtp106.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030386AbXBTVTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:19:00 -0500
X-YMail-OSG: ABTwn.8VM1lHJYULDUhL1Bd44Jg5uab_x2ci8M4z55jjXZTn2EfELYnVow2LbXxOGsMAGDVg2wXbpoWYN6p00OMRTBGfJCSBk0b2v0sIWfPWoRlKv4fi2pFo7_rj8tQB0AK.kByji_DT4v8Ki5.F6PYIosEiW0RNgA--
Date: Tue, 20 Feb 2007 15:18:49 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>, greg@kroah.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: securityfs_create_dir strange comment
Message-ID: <20070220211849.GA3416@vino.hallyn.com>
References: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jan Engelhardt (jengelh@linux01.gwdg.de):
> Hello list,
> 
> 
> in security/inode.c, the comment for securityfs_create_dir() reads:
> 
> 	If securityfs is not enabled in the kernel, the value -ENODEV 
> 	will be returned.  It is not wise to check for this value, but 
> 	rather, check for NULL or !NULL instead as to eliminate the need 
> 	for #ifdef in the calling code.
> 
> What is the actual callee that can return NULL - and what should 
> module_init() of a module return when securityfs_create_dir() returns 
> NULL?

Hmm, this came from GregKH.  It does seem based on the code that
checking for -ENODEV is necessary, so I don't understand the comment.

thanks,
-serge
