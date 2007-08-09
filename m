Return-Path: <linux-kernel-owner+w=401wt.eu-S937171AbXHIJS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937171AbXHIJS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbXHIJSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:18:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56600 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764121AbXHIJST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:18:19 -0400
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
From: Kay Sievers <kay.sievers@vrfy.org>
To: Javier Pello <javier.pello@urjc.es>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <46BADAA8.70404@urjc.es>
References: <46B37CF7.2020803@urjc.es>
	 <20070806142451.5d28d41c@gondolin.boeb lingen.de.ibm.com>
	 <46B7832B.6010808@urjc.es>
	 <20070807125844.4d756b04@gondo   l	in.boeblingen.de.ibm.com>
	 <3ae72650708070446y6452d13jb7cd802119dab3ce@mail .gmail.com>
	 <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	 <46B869C6.3090708@urjc.es> <1186491472.3611.33.camel@lov.localdomain>
	 <46B87ACA.7010501@urjc.es> <1186495705.3611.39.camel@lov.localdomain>
	 <46BADAA8.70404@urjc.es>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 11:21:30 +0200
Message-Id: <1186651290.21247.3.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+RFKnwC3/oRX0hverMvfiZv3ipdR5Kc5bUAGj
 au24aA9xwHEm0e+0cE4dX98xuNmMby9luvYtmAtwKg636+MvRM
 VRgGU1UW9j11EAk9AP3xuZXvGmFTCNO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 11:13 +0200, Javier Pello wrote:
> On Tue, 07 Aug 2007, Kay Sievers wrote:
> > Nope, you would just fulfill in a completely generic way all outstanding
> > requests when you are ready. All requests are all nicely grouped and
> > visible in sysfs. There would be no need of coding your own device
> > specific rebind. No timeout is needed or wanted, all requests would stay
> > until userspace has handled them successfully or canceled them.
> 
> If I'm not mistaken, as it is now, requests are not grouped in any way.
> The only hint that a firmware loading request is in progress are a couple
> of files in the device directory in sysfs. Should I run, at boot, through
> all the device directories to check which firmware requests are pending?

/sys/class/firmware/* contains all pending requests, no need to search
anywhere else.

Kay

