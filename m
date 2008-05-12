Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbYELRMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbYELRMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYELRMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:12:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:40092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYELRMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:12:06 -0400
Date: Mon, 12 May 2008 10:11:34 -0700
From: Greg KH <gregkh@suse.de>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       samuel.thibault@ens-lyon.org, rjw@sisk.pl
Subject: Re: [PATCH] Fix c67x00-ll-hpi compilation failure (bug #10627)
Message-ID: <20080512171134.GA4168@suse.de>
References: <1210588531.3058.31.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1210588531.3058.31.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 07:35:31PM +0900, Fernando Luis Vázquez Cao wrote:
> This patch fixes bug #10627 which caused the compilation error below.
> 
> CC [M]  drivers/usb/c67x00/c67x00-ll-hpi.o
> drivers/usb/c67x00/c67x00-ll-hpi.c: In function `ll_recv_msg':
> drivers/usb/c67x00/c67x00-ll-hpi.c:243: erreur: `HZ' undeclared (first use in this function)
> drivers/usb/c67x00/c67x00-ll-hpi.c:243: erreur: (Each undeclared identifier is reported only once
> drivers/usb/c67x00/c67x00-ll-hpi.c:243: erreur: for each function it appears in.)
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Already in my tree and linux-next and queued up to be sent in a bit to
Linus.

thanks,

greg k-h
