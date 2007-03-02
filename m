Return-Path: <linux-kernel-owner+w=401wt.eu-S2992464AbXCBOIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992464AbXCBOIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992465AbXCBOIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:08:43 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:61734 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992464AbXCBOIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:08:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=VZYZYCO6Os/ClzC4N7AXe62yxGUD8aaM6rqdFg2IGKZUwP70Xq0rclQ0QNCVnJh5pGIUKBe1m3mouuonKNWWiIpJP9ROLUE8poIlBf22U4nmVJgRUo697+EcaA+GvhT5z6PAf9dbKJ3TLcvQ6SptJmjb7gT2LpqDnORKj2Jyah8=
Subject: Re: [RFC] Arp announce (for Xen)
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Andi Kleen <ak@muc.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070302125428.GA67405@muc.de>
References: <20070301232443.195603797@goop.org>
	 <20070301232529.648076372@goop.org> <20070301164214.4a40bc59@freekitty>
	 <45E7764A.7000100@goop.org> <20070301173030.754514ec@freekitty>
	 <20070302125428.GA67405@muc.de>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 09:08:38 -0500
Message-Id: <1172844518.4864.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-03 at 13:54 +0100, Andi Kleen wrote:

> Seems like the right solution to me (if it works)

I like it as well given the simple change. 
These are the kind of optimizations that justify offloading things to
the kernel (instead of user space) i.e very little lines of code, covers
a large number of user-desires, and can be turned off if you want to do
something complex. _Almost_ elegant Stephen;->

cheers,
jamal

