Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYKATQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYKATQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYKATQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:16:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59981 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYKATQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:16:17 -0400
Date: Sat, 1 Nov 2008 19:16:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
Message-ID: <20081101191614.GA28946@ZenIV.linux.org.uk>
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk> <20081101191250.GA7588@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081101191250.GA7588@x200.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 10:12:50PM +0300, Alexey Dobriyan wrote:
> On Sat, Nov 01, 2008 at 06:20:19PM +0000, Al Viro wrote:
> > -static int __init el3_common_init(struct net_device *dev)
> > +static int __devinit el3_common_init(struct net_device *dev)
> 
> Al, here is much better patch:

[essentially kill devinit/cpuinit]

What the hell makes it better?
