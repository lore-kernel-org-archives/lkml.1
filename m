Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbYEAWBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbYEAWBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762393AbYEAWBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:01:21 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:61760 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761260AbYEAWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:01:20 -0400
Subject: Re: [PATCH] fix flags length in net 9p
From: Daniel Walker <dwalker@mvista.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       lucho@ionkov.net, ericvh@gmail.com
In-Reply-To: <20080501214138.GT29330@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
	 <20080501141919.78b7dc4f.akpm@linux-foundation.org>
	 <1209677160.12461.267.camel@localhost.localdomain>
	 <20080501214138.GT29330@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Thu, 01 May 2008 15:01:18 -0700
Message-Id: <1209679278.12461.268.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 00:41 +0300, Adrian Bunk wrote:

> > The check that's in -rt for this uses BUILD_BUG_ON(), and it's extremely
> > cryptic when there is a failure .. Most people will be baffled why the
> > build stopped. If a check went into mainline it should at least give you
> > some sort of idea what's happening ..
> 
> A cryptic compile error is _much_ better than a hard to find runtime 
> error.

I think we ultimately want something informative if it's possible.
That's what I want.

Daniel

