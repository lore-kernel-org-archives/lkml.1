Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYCJSNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYCJSNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYCJSN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:13:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37471 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYCJSN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:13:26 -0400
Date: Mon, 10 Mar 2008 11:13:19 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
       Colin Leroy <colin@colino.net>
Subject: Re: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
Message-ID: <20080310181319.GA7500@tree.beaverton.ibm.com>
References: <47D47B11.1000303@tiscali.nl> <20080310084633.5246ecfe@paperstreet.colino.net> <1205136413.8621.3.camel@pasglop> <47D4EFC1.1050403@tiscali.nl> <64d5b5e6dfd0d1820d21db323ef88e25@kernel.crashing.org> <47D5068F.8050709@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D5068F.8050709@tiscali.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 10:59:43AM +0100, Roel Kluin wrote:

> > The & 0xff here is bogus anyway; temp is only ever used as an u8,
> > so just declare it as that, or do proper overflow/underflow checking
> > on it.  The patch will need testing on hardware too, since it changes
> > behaviour (it should be a bugfix, but who knows).
> 
> Maybe someone can test this?

I did.  No regressions observed and it fixes that bug as well.  Sorry I
didn't catch it earlier... :/

Acked-by: Darrick J. Wong <djwong@us.ibm.com>

--D
