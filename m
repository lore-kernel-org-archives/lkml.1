Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbXETXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbXETXKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760420AbXETXKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 19:10:32 -0400
Received: from outbound-mail-59.bluehost.com ([69.89.20.39]:37885 "HELO
	outbound-mail-59.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760401AbXETXKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 19:10:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jon Smirl <jonsmirl@verizon.net>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Sun, 20 May 2007 16:10:31 -0700
User-Agent: KMail/1.9.6
Cc: Jesse Barnes <jesse.barnes@intel.com>, jonsmirl@gmail.com,
       linux-kernel@vger.kernel.org
References: <200705171423.46748.jesse.barnes@intel.com> <pan.2007.05.20.17.41.22@gmail.com>
In-Reply-To: <pan.2007.05.20.17.41.22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201610.32170.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 20, 2007, Jon Smirl wrote:
> On Thu, 17 May 2007 14:23:45 -0700, Jesse Barnes wrote:
> > In collaboration with the FB guys, we've been working on enhancing the
> > kernel's graphics subsystem in an attempt to bring some sanity to the
> > Linux graphics world and avoid the situation we have now where several
> > kernel and userspace drivers compete for control of graphics devices.
>
> How is supporting different users logged into each head going to work?
> The original model for this was to give each head its own fbdev device.
> It is important that each user be able to set their own mode without
> being root.

With the interfaces implemented here, a userspace application can create a 
multiseat environment either with a single graphics card with multiple 
outputs or multiple cards.  It could do this by creating several frame 
buffer objects and associating them with whatever CRTCs were available, 
and managing input via existing APIs.  I don't know of anyone that's done 
this yet though...

Jesse
