Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbXHCWIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbXHCWIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762210AbXHCWH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:07:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58445 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762642AbXHCWHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:07:55 -0400
Date: Fri, 3 Aug 2007 23:07:52 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Chris Snook <csnook@redhat.com>
Cc: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>,
       linux-kernel@vger.kernel.org
Subject: Re: Dynamic major/minor numbers (or dropping them completely)
Message-ID: <20070803220752.GU21089@ftp.linux.org.uk>
References: <46B21833.600@aladin.ro> <46B39A8F.5070809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B39A8F.5070809@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 05:13:51PM -0400, Chris Snook wrote:
> You're correct that dynamic major/minor numbers are sufficient for most 
> purposes, but embedded users really need their static numbers.  As for 
> ripping out major/minor numberings, that's a non-starter.  Too much of our 
> device management infrastructure is based around this numbering scheme, and 
> there isn't really anything wrong with it to justify breaking everything in 
> the change.
> 
> As a rule of thumb, if you ever find yourself wondering why we still 
> support doing statically something we can now do dynamically, the answer is 
> generally that doing it dynamically sucks for embedded.

And not only embedded.  I'm quite happy _not_ running udev on anything
I have root on, except for one test box set exactly to make sure that
patches do not break things for udev-infested boxen.
