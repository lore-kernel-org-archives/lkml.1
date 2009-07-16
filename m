Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbZGPWBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbZGPWBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbZGPWBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:01:37 -0400
Received: from kroah.org ([198.145.64.141]:38142 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939AbZGPWBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:01:37 -0400
Date: Thu, 16 Jul 2009 15:00:48 -0700
From: Greg KH <greg@kroah.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Matthias Urlichs <smurf@smurf.noris.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: drivers/usb/serial/option.c compiler warning
Message-ID: <20090716220048.GD10820@kroah.com>
References: <1247639027.2437.9.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1247639027.2437.9.camel@ht.satnam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:53:47AM +0530, Jaswinder Singh Rajput wrote:
> I am getting compiler warning in linus tree:
> 
>   CC [M]  drivers/usb/serial/option.o
> drivers/usb/serial/option.c: In function ‘option_instat_callback’:
> drivers/usb/serial/option.c:834: warning: unused variable ‘serial’
> drivers/usb/serial/option.c: In function ‘option_open’:
> drivers/usb/serial/option.c:930: warning: unused variable ‘serial’
> 
> This fixes the warning in my case, hope this will be helpful :

Hm, you forgot a Signed-off-by: line, and someone beat you to sending
this change to me a few hours earlier, sorry.

thanks,

greg k-h
