Return-Path: <linux-kernel-owner+w=401wt.eu-S965417AbXCLJ0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbXCLJ0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXCLJ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:26:10 -0400
Received: from ozlabs.org ([203.10.76.45]:60047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXCLJ0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:26:09 -0400
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F51C25.76E4.0078.0@novell.com>
References: <1173655694.32234.213.camel@localhost.localdomain>
	 <45F51C25.76E4.0078.0@novell.com>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 20:25:10 +1100
Message-Id: <1173691510.32234.222.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 08:23 +0000, Jan Beulich wrote:

> I have to admit that I don't see the point here - I can't seem to make
> any sense of the OR... Jan

At least one other person thought that:

	#define BUILD_BUG_ON_ZERO(e) BUILD_BUG_ON((e) == 0)

OTOH, BUILD_BUG_OR_ZERO says what happens: either it's a build bug, or
it's zero.

Hope that clarifies,
Rusty.


