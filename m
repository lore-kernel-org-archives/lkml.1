Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697Ab0BZANW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:13:22 -0500
Received: from kroah.org ([198.145.64.141]:43471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593Ab0BZANV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:13:21 -0500
Date: Thu, 25 Feb 2010 15:25:29 -0800
From: Greg KH <greg@kroah.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, david-b@pacbell.net,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA
 support
Message-ID: <20100225232528.GA24155@kroah.com>
References: <4B7CAF95.6020306@gmail.com>
 <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl>
 <4B85EE88.5050506@kernel.org>
 <201002250503.09327.oliver@neukum.org>
 <4B8609CE.5000705@kernel.org>
 <20100225161413.GA1229@kroah.com>
 <51f3faa71002251515k51354eb6y3e2cfd1558dba2f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa71002251515k51354eb6y3e2cfd1558dba2f1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 05:15:49PM -0600, Robert Hancock wrote:
> > For now, I'd like to not enable this, given the huge risks and no known
> > benifit.
> 
> "Huge risks" is likely a bit melodramatic

No it is not.  This has the ability to break USB functionality that
currently works just fine for a user.  That's not acceptable.

And yes, we can fix things after-the-fact with blacklists, but as Tejun
so aptly described, it is a major pain to do so, and lots of users just
get frustrated and never tell us that problems happen.

thanks,

greg k-h
