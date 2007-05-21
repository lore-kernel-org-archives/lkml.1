Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXEUB3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXEUB3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXEUB33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:29:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36616 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbXEUB33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:29:29 -0400
Message-ID: <4650F5F2.4000305@garzik.org>
Date: Sun, 20 May 2007 21:29:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Jon Smirl <jonsmirl@gmail.net>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <pan.2007.05.20.17.41.22@gmail.com>	 <200705201610.32170.jbarnes@virtuousgeek.org> <9e4733910705201747n1847f7b1wd57a8e8640a857a8@mail.gmail.com>
In-Reply-To: <9e4733910705201747n1847f7b1wd57a8e8640a857a8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:
> This design still requires a global server app since the heads share a
> single device.
> I am always concerned that the root priv code in the X server is a
> potential security hole. I would like to move away from a model where
> there is a global controlling app. I don't think we need a global
> controlling app at all.


If you have multiple "controlling" apps competing for a single device, 
that either implies complexity in each app for sharing control, or 
moving even more code into the kernel for 2D and 3D.

I don't think the kernel community is yet interested in moving 
everything of consequence into the kernel.

	Jeff


