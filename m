Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYJNCP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYJNCP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYJNCPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:15:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:37717 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbYJNCPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:15:49 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       yhlu.kernel@gmail.com
In-Reply-To: <20081013.184535.57239267.davem@davemloft.net>
References: <20081014005428.EC2D8DDF93@ozlabs.org>
	 <48F3F014.3050406@zytor.com> <1223948488.8157.309.camel@pasglop>
	 <20081013.184535.57239267.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 13:15:37 +1100
Message-Id: <1223950537.8157.313.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 18:45 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 14 Oct 2008 12:41:27 +1100
> 
> > It has to be a pointer tho, thus what do we want ? Something that takes
> > a pointer to a resource_size_t or to a whole struct resource ? In the
> > later case, do we want to print the whole flags too ?
> 
> Yes, that's sort of the ugly aspect of this.
> 
> Taking a resource would be cool, and you could use some post modifier
> character to say which part to print

That's a good idea, there's quite a few areas where we don't want the
flags.. I'll see if I can cook up something after I've finished
preparing the powerpc tree for Linus to pull.

Cheers,
Ben.


