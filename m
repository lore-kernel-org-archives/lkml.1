Return-Path: <linux-kernel-owner+w=401wt.eu-S965047AbXCANUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965047AbXCANUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965049AbXCANUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:20:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:33919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965047AbXCANUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:20:04 -0500
Message-ID: <45E6D309.5050409@suse.de>
Date: Thu, 01 Mar 2007 14:20:09 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Gerd Hoffmann <kraxel@suse.de>,
       linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@hp.com>,
       Kevin Stansell <kstansel@us.ibm.com>
Subject: Re: [patch] Add insmod option to force the use of the backup timer.
References: <20070228102346.115707000@suse.de> <20070228185505.GA17193@redhat.com>
In-Reply-To: <20070228185505.GA17193@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, Feb 28, 2007 at 11:23:46AM +0100, Gerd Hoffmann wrote:
>  > The test which automatically enables the backup timer on some HP
>  > machines doesn't trigger on other hardware which needs the backup
>  > timer too.
> 
> Did you figure out *why* that test doesn't trigger?

I didn't, probably a slightly different hardware bug.

> Making that work seems a better solution to me than adding magic
> options that users won't know they have to use.

Sure, that would be better.  I'll leave that to the ibm guys who own the
hardware in question ;)

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
