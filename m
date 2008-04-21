Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYDUOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYDUOzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYDUOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:55:28 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35799 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYDUOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:55:27 -0400
Date: Mon, 21 Apr 2008 07:55:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [RFC 0/3] Examples for the new sparse context tracking functionality
Message-ID: <20080421145525.GB9153@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080410134810.629048000@sipsolutions.net> <20080419233338.GG20138@linux.vnet.ibm.com> <1208766355.26186.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208766355.26186.37.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 10:25:55AM +0200, Johannes Berg wrote:
> 
> > At some point in the future, we might want to distinguish between
> > the different flavors of RCU -- except that there is already common
> > code that doesn't care which flavor of RCU is in use, as long as
> > some sort of RCU is present.  So make that "some point in the distant
> > future"...
> 
> No big deal, just declare
> 
> my_specific_rcu_get() __acquires(RCU) __acquires(specificRCU);
> 
> and then annotate whatever needs the specific RCU type with
> __requires(specificRCU)

Cute!!!  I didn't realize you could mark a single interface with
multiple __acquires() markings.

So if there is at least one match, sparse is happy?

							Thanx, Paul
