Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYDISOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYDISOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYDISOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:14:37 -0400
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:59793 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753009AbYDISOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:14:36 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: DRM modesetting & sysfs
Date: Wed, 9 Apr 2008 11:12:28 -0700
User-Agent: KMail/1.9.9
Cc: Jakob Bornecrantz <wallbraker@gmail.com>, dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200804081317.43712.jbarnes@virtuousgeek.org> <1207761826.14588.390.camel@localhost> <200804091039.09050.jbarnes@virtuousgeek.org>
In-Reply-To: <200804091039.09050.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804091112.28838.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2008 10:39 am Jesse Barnes wrote:
> > With VGA (i.e. ADPA) output ?
> >
> > If so, that's the problem. From what I can tell of i915 docs, they only
> > support hotplug for SDVO devices only, so that's how it's coded up at
> > the moment. For i945/i965 it can go the whole hog.
>
> Ah, maybe that's it, yeah I'm using VGA via ADPA.  I don't see any IIR or
> PIPEASTAT bits set when I plug in the display, so I guess we're stuck with
> manually probing on these devices.

Looks like i915 may support TV hotplug too, though I haven't finished the TV 
bits yet; I'll see about that today.

However, on my 965 I get hotplug interrupts, the output is configured, and I 
even get uevents with the new sysfs code, yay! :)

Jesse
