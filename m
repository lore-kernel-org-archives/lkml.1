Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZBRCIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZBRCIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZBRCIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:08:00 -0500
Received: from kroah.org ([198.145.64.141]:54894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752267AbZBRCIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:08:00 -0500
Date: Tue, 17 Feb 2009 17:44:11 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] staging: &&/|| typo
Message-ID: <20090218014411.GA30552@kroah.com>
References: <49986CCF.4010005@gmail.com> <adamycn7aqx.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamycn7aqx.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 11:36:54AM -0800, Roland Dreier wrote:
>  > -	if(fifo_size != 0x400 || fifo_size != 0x2000)
>  > +	if(fifo_size != 0x400 && fifo_size != 0x2000)
> 
> What does the presence of this bug say about the probability that this
> code has ever been used for anything real?

With the comedi drivers, I really don't know, they have not had that
much wide exposure before, despite being around for a very long time.

thanks,

greg k-h
