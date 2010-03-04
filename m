Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0CDX03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:26:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab0CDX01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:26:27 -0500
Message-ID: <4B90419E.20309@redhat.com>
Date: Thu, 04 Mar 2010 17:26:22 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: dump/restore not supported for ext4
References: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Hi,
> 
> I should have researched it more:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651
> https://lists.ubuntu.com/archives/universe-bugs/2009-June/098729.html
> 
> Looks like it's broken, I agree with the reporters, dump should abort if
> it is dealing with an ext4 filesystem, since you cannot restore data
> from an ext4 dump.

does dump still read the mounted block device directly?  I'm not familiar
with the internals (need to look, I guess) but if so, I wonder how that
+ delalloc get along...

-Eric

> Justin.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

