Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXDGBWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXDGBWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 21:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964883AbXDGBWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 21:22:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbXDGBWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 21:22:08 -0400
Date: Fri, 6 Apr 2007 18:21:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Zachary Amsden <zach@vmware.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD
 sharing
Message-Id: <20070406182155.e72d8f95.akpm@linux-foundation.org>
In-Reply-To: <4616E86D.30904@goop.org>
References: <20070404191151.009821039@goop.org>
	<20070404191205.392155702@goop.org>
	<20070406164139.08cd343b.akpm@linux-foundation.org>
	<4616DFB2.4020802@goop.org>
	<20070406172844.12f7b8e7.akpm@linux-foundation.org>
	<4616E86D.30904@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 17:40:13 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > Something like that.  I don't want to redo my patch if we're going to change
> > your patch ;)
> >   
> 
> OK.  I won't specifically redo it on top of your patches, but I'll
> rework it to remove the inline function and add the if() statement.  Do
> you want an incremental update or a complete replacement?
> 

Thanks.  A replacement would suit.
