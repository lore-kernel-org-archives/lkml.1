Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYCNBdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYCNBdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYCNBdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:33:16 -0400
Received: from testure.choralone.org ([194.9.77.134]:46254 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYCNBdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:33:16 -0400
Date: Thu, 13 Mar 2008 21:33:03 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       avorontsov@ru.mvista.com
Subject: Re: [patch 2.6.25-rc5 2/2] gpiochip_reserve()
Message-ID: <20080314013303.GA15600@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
	avorontsov@ru.mvista.com
References: <200803131552.22122.david-b@pacbell.net> <20080313160606.219166f5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313160606.219166f5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 04:06:06PM -0700, Andrew Morton wrote:
 > On Thu, 13 Mar 2008 14:52:21 -0800
 > David Brownell <david-b@pacbell.net> wrote:
 > 
 > > +int __init __must_check gpiochip_reserve(int start, int ngpio)
 > 
 > I applaud the addition of __msut_check to a newly-added function of this
 > kind, but we usually only add the tag to the declaration, not to the
 > definition as well.

A bit unfortunate really, given that use of ctags and friends in some editors
jumps to the first definition they come across, so if the prototype is stuffed
somewhere in include/, it shows the definitions from drivers or fs or wherever
that doesn't have the tag.

Given it doesn't cost us anything except a few more bytes in the source code,
is consistency such a bad thing?

	Dave

-- 
http://www.codemonkey.org.uk
