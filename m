Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZLCOIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZLCOIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZLCOIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:08:53 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60257 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977AbZLCOIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:08:52 -0500
Subject: Re: [PATCH] modules: don't export section names of empty sections
 via sysfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, kyle@mcmartin.ca,
       akpm@linux-foundation.org, roland@redhat.com, dave@hiauly1.hia.nrc.ca,
       torvalds@linux-foundation.org
In-Reply-To: <200912031750.41240.rusty@rustcorp.com.au>
References: <20091202232915.GA2251@p100.box>
	 <200912031750.41240.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 08:08:53 -0600
Message-Id: <1259849333.17964.48.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 17:50 +1030, Rusty Russell wrote:
> On Thu, 3 Dec 2009 09:59:15 am Helge Deller wrote:
> > [PATCH] modules: don't export section names of empty sections via sysfs
> 
> Thanks, applied.
> 
> Ah, I see Linus snuck this in before the release.  Excellent.

That's great.  The next step is probably to find out why the toolchain
is doing this ... generating zero length allocated segments seems to be
somewhat deviant behaviour ...

James


