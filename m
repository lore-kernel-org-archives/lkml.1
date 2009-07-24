Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZGXVcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZGXVcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZGXVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:32:34 -0400
Received: from lazybastard.de ([212.112.238.170]:58333 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbZGXVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:32:33 -0400
Date: Fri, 24 Jul 2009 23:32:19 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 34/54] Staging: hv: remove STRUCT_PACKED and STRUCT_ALIGNED defines
Message-ID: <20090724213218.GA13702@logfs.org>
References: <20090717180850.873962925@mini.kroah.org> <20090717180921.448023599@mini.kroah.org> <200907210146.41399.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907210146.41399.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 July 2009 01:46:41 +0200, Arnd Bergmann wrote:
> On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> > @@ -43,7 +43,7 @@ typedef struct _RING_BUFFER {
> >         // volatile u32 InterruptMask;
> >         // Ring data starts here + RingDataStartOffset !!! DO NOT place any fields below this !!!
> >      u8         Buffer[0];
> > -} STRUCT_PACKED RING_BUFFER;
> > +} __attribute__((packed)) RING_BUFFER;
> >  
> 
> The data structure is actually packed already, the attribute does not make it better
> and could be removed. We also have __packed as a shortcut for __attribute__((packed)).

Honestly, I don't know how useful __packed really is.  In a shared
kernel/userspace header, it is only defined for the kernel.

Jörn

-- 
Do not stop an army on its way home.
-- Sun Tzu
