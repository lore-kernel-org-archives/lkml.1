Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZHTQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZHTQLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZHTQLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:11:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbZHTQLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:11:46 -0400
Date: Thu, 20 Aug 2009 18:11:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 4/7] kfifo: rename kfifo_put... into kfifo_in... and
	kfifo_get... into kfifo_out...
Message-ID: <20090820161147.GB29994@basil.fritz.box>
References: <1250714990.13476.3.camel@wall-e> <1250715606.13476.15.camel@wall-e> <1250715819.3407.88.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250715819.3407.88.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 02:03:39PM -0700, Joe Perches wrote:
> On Wed, 2009-08-19 at 23:00 +0200, Stefani Seibold wrote:
> > rename kfifo_put... into kfifo_in... to prevent miss use of old non in kernel-tree drivers
> > ditto for kfifo_get... -> kfifo_out...
> 
> I would have thought
> 	kfifo_put -> kfifo_out
> 	kfifo_get -> kfifo_in
> but maybe that's just me.

I don't think it's fruitful to criticize other people's variable
names. The rule in Linux is normally: if you write the code
you get to name it the way you want.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
