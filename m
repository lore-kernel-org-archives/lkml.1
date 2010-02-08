Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0BHWrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:47:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1885 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab0BHWrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:47:12 -0500
Subject: Re: [PATCH] drivers/usb: Convert concatenated __FILE__ to %s,
 __FILE__
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100208044917.GC30314@kroah.com>
References: <1265421073.10226.56.camel@Joe-Laptop.home>
	 <20100208044917.GC30314@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 14:47:11 -0800
Message-ID: <1265669231.2135.12.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-07 at 20:49 -0800, Greg KH wrote:
> On Fri, Feb 05, 2010 at 05:51:13PM -0800, Joe Perches wrote:
> > Reduces string space a bit
> It does?  Does gcc optimize all of the __FILE__ instances to point to
> the same place in the object?

Yes, just like any other duplicated const string.

Converting a source unit with a single use of __FILE__
wastes space (direct string vs pointer + "%s" + string)

Multiple conversions generally save space.


