Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYCXHGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYCXHGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 03:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYCXHGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 03:06:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbYCXHGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 03:06:13 -0400
Date: Mon, 24 Mar 2008 08:09:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Kai <epimetreus@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Serious performance regression in Wine applications and Linux 2.6.24.*
Message-ID: <20080324070915.GA15022@one.firstfloor.org>
References: <1206310206.17373.1243881033@webmail.messagingengine.com> <87tziw7p3b.fsf@basil.nowhere.org> <1206341640.31427.1243929483@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206341640.31427.1243929483@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you explain more clearly what you mean with vmstat?

Open shell window. Enter "vmstat 1". Run Wine application. Watch "cs" 
column over time.

An possible improvement would be also to use a larger number than 1 to get
values over long time.

Compare that value to the old kernel.

> 
> Also, I'd like to find a way to feasibly do the git bisect (I assume you
> basically mean testing against every change in sequence since .23), but

Yes, although it is just every 1+log2 changes

> I'd like some advice on how to do this, and how to do it reasonably
> expeditiously.

Type git bisect into google, there are lots of tutorials.

-Andi


> 
