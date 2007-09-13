Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbXIMBoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbXIMBoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760602AbXIMBoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:44:11 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35013 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbXIMBoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:44:09 -0400
Date: Thu, 13 Sep 2007 10:43:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michal Januszewski <spock@gentoo.org>
Cc: Paulo Marques <pmarques@grupopie.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] uvesafb: Don't access VGA registers directly when running on non-x86
Message-ID: <20070913014357.GB26541@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michal Januszewski <spock@gentoo.org>,
	Paulo Marques <pmarques@grupopie.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070911081752.GA19495@linux-sh.org> <46E67EFD.2040902@grupopie.com> <20070911115346.GA23493@linux-sh.org> <46E687ED.9000802@grupopie.com> <20070911123159.GA23692@linux-sh.org> <20070911230959.GA16406@spock.one.pl> <20070912004437.GA26720@linux-sh.org> <20070912194151.GA5410@spock.one.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912194151.GA5410@spock.one.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 09:41:51PM +0200, Michal Januszewski wrote:
> The VGA registers are only available at their legacy IO locations on
> x86. Don't try to access them when running on other arches.
> 
> Note that the code accessing them directly is just an optimization
> (limits slow BIOS function calls).  We don't lose any functionality 
> by using BIOS calls instead of it on non-x86.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>

Looks fine, thanks Michal.
