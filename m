Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYJNBqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYJNBqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYJNBp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:45:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56507
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbYJNBp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:45:59 -0400
Date: Mon, 13 Oct 2008 18:45:35 -0700 (PDT)
Message-Id: <20081013.184535.57239267.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1223948488.8157.309.camel@pasglop>
References: <20081014005428.EC2D8DDF93@ozlabs.org>
	<48F3F014.3050406@zytor.com>
	<1223948488.8157.309.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 14 Oct 2008 12:41:27 +1100

> It has to be a pointer tho, thus what do we want ? Something that takes
> a pointer to a resource_size_t or to a whole struct resource ? In the
> later case, do we want to print the whole flags too ?

Yes, that's sort of the ugly aspect of this.

Taking a resource would be cool, and you could use some post modifier
character to say which part to print.
