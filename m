Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZBRSOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZBRSOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZBRSOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:14:38 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:38763 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165AbZBRSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:14:37 -0500
Subject: Re: [PATCH] staging/wlan-ng: block ioctls until card fully
 initialised
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Greg KH <greg@kroah.com>
Cc: Karl Relton <karllinuxtest.relton@ntlworld.com>,
       lkml <linux-kernel@vger.kernel.org>,
       wlan-devel <linux-wlan-devel@lists.linux-wlan.com>
In-Reply-To: <20090218022117.GB32325@kroah.com>
References: <1234213202.6875.70.camel@dellpc>
	 <20090209211700.GA10742@kroah.com> <1234478293.17792.1.camel@dellpc>
	 <1234873158.2891.29.camel@localhost.localdomain>
	 <20090218022117.GB32325@kroah.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 18:14:34 +0000
Message-Id: <1234980874.2877.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 18:21 -0800, Greg KH wrote:
> On Tue, Feb 17, 2009 at 12:19:18PM +0000, Richard Kennedy wrote:
> > Add a mutex to block ioctls before the card is fully initialised and
> > only allow one ioctl at a time.
> > This stops udev trying to load the firmware before to card is fully up.
> > 
> > patch ported from wlan-ng-devel
> > 
> > Karl Relton <karllinuxtest.relton@ntlworld.com> spotted that this was
> > missing from the staging version,
> > http://lists.linux-wlan.com/pipermail/linux-wlan-devel/2009-February/003890.html 
> 
> Karl sent me a patch a few days before you that also added this
> functionality.
> 
> Unfortunatly, both of your patches don't apply to the latest version of
> the wlan-ng driver as it has had a lot of work done on it recently.
> 
> Could one of you grab the linux-next tree and make a patch up against
> the version in it so that I can apply this?
> 
> thanks,
> 
> greg k-h
Sorry about that, I'd forgotten that wlan-ng was included in linux-next.

I've updated the patch and am just testing it & will post it shortly.

BTW thanks to Moritz Muehlenhoff for the clean-ups. 

regards 
Richard



