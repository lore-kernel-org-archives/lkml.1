Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZGXXGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZGXXGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZGXXGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:06:37 -0400
Received: from lazybastard.de ([212.112.238.170]:37915 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZGXXGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:06:36 -0400
Date: Sat, 25 Jul 2009 01:06:20 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, virtualization@lists.linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [patch 34/54] Staging: hv: remove STRUCT_PACKED and STRUCT_ALIGNED defines
Message-ID: <20090724230619.GB13702@logfs.org>
References: <20090717180850.873962925@mini.kroah.org> <20090717180921.448023599@mini.kroah.org> <200907210146.41399.arnd@arndb.de> <20090724213218.GA13702@logfs.org> <20090724145025.12da5a6e@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090724145025.12da5a6e@nehalam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 July 2009 14:50:25 -0700, Stephen Hemminger wrote:
> On Fri, 24 Jul 2009 23:32:19 +0200
> Jörn Engel <joern@logfs.org> wrote:
> 
> > On Tue, 21 July 2009 01:46:41 +0200, Arnd Bergmann wrote:
> > > 
> > > The data structure is actually packed already, the attribute does not make it better
> > > and could be removed. We also have __packed as a shortcut for __attribute__((packed)).
> > 
> > Honestly, I don't know how useful __packed really is.  In a shared
> > kernel/userspace header, it is only defined for the kernel.
> 
> As I remember, gcc generates worse code for packed structures on many architectures
> since it may have to do byte fetchs/recombining to avoid unaligned
> accesses.

I was talking about "__packed" vs. "__attribute__((packed))".  But yes,
avoiding packed structures where possible is a good idea.

Jörn

-- 
"[One] doesn't need to know [...] how to cause a headache in order
to take an aspirin."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
