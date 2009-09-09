Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZIITWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZIITWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZIITWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:22:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36734 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZIITWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:22:39 -0400
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0909091217570.32267@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com>
	 <1251129384.22398.7166.camel@nimitz>
	 <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
	 <1251150156.22398.8289.camel@nimitz>
	 <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com>
	 <1252510129.14385.37045.camel@nimitz>
	 <alpine.DEB.1.00.0909091217570.32267@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 12:22:37 -0700
Message-Id: <1252524157.14385.37942.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 12:18 -0700, David Rientjes wrote:
> On Wed, 9 Sep 2009, Dave Hansen wrote:
> > I don't know of any offhand.  Someone mentioned oprofile buffers at some
> > point, but I looked through it and it didn't pop out at me.
> 
> Their length and element size fit the prerequisites of using flex array, 
> but they cannot be copied to userspace as a string the way we can with 
> vmalloc'd memory.

It shouldn't be too hard to do that, though.  Although a bit silly to
have make a copy_to_user() call for each ->parts[] page, it would be
pretty easy to implement.  

-- Dave

