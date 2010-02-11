Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0BKUap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:30:45 -0500
Received: from 1wt.eu ([62.212.114.60]:56316 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab0BKUan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:30:43 -0500
Date: Thu, 11 Feb 2010 21:22:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       lasse.collin@tukaani.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100211202201.GA31110@1wt.eu>
References: <4B744E13.8040004@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B744E13.8040004@kernel.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, Feb 11, 2010 at 10:36:03AM -0800, J.H. wrote:
(...)
> I'm personally leaning towards option 1, though personally don't really
> have a preference on the migration options, as both obviously offer
> different advantages, and again this e-mail is more to spur on the
> discussion and come to some general consensus across all of the groups
> concerned before moving forward with a more specific plan.

I too think option 1 is better for various reasons, one of them being
that gzip is present on every platform and OS right now, while bzip2
is orders of magnitude less common. Of course on Linux we all have both
of them, but I find it important to continue to provide the sources in
a standard format. Also, on the platforms where bzip2 is not installed
by default, switching to xz should not be that hard, because either bz2
is currently not used and that changes nothing, or the users managed to
install it themselves, and they'll simply have to do the same with xz.

I don't have much preference for any of the two migration options though.

Just my 2 cents,
Willy

