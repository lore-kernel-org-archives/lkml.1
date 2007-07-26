Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbXGZA3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbXGZA3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbXGZA3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:29:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbXGZA3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:29:30 -0400
Date: Wed, 25 Jul 2007 17:28:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Gabriel C <nix.or.die@googlemail.com>, Dave Hansen <haveblue@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc1-mm1
Message-Id: <20070725172845.8dec8ec5.akpm@linux-foundation.org>
In-Reply-To: <20070726000705.GB21056@suse.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com>
	<20070725185328.GA28199@uranus.ravnborg.org>
	<46A7A1EF.8060307@zytor.com>
	<46A7B983.90407@googlemail.com>
	<46A7BB12.7060504@googlemail.com>
	<20070726000705.GB21056@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 17:07:05 -0700
Greg KH <gregkh@suse.de> wrote:

> > Guessing is this patch ?
> > 
> > gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch:           __tracedata_end = .;
> > gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch:+  _sdata = .;                     /* End of text section */
> 
> This patch is a horrible hack to try to see if kobjects are static and
> not dynamically created.

You could perhaps use something like module_address_lookup() for this
debugging aid.
