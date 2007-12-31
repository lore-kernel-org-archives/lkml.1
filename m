Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXLaNoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXLaNoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXLaNoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:44:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:32874 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbXLaNoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:44:15 -0500
Date: Mon, 31 Dec 2007 14:44:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] fixup genksyms usage/getopt
Message-ID: <20071231134416.GA22317@uranus.ravnborg.org>
References: <200711100932.21024.vapier.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711100932.21024.vapier.adi@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 09:32:20AM -0500, Mike Frysinger wrote:
> The usage does not mention the "-a,--arch" or "-T,--dump-types" options, so
> add them.  The calls to getopt() seem to mention options that no longer exist
> (some "k" and "p" thingy) but omits the "h" option which means using '-h'
> actually triggers the error code path, so update those as well.

Thanks, applied.

	Sam
