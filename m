Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbXFKSwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbXFKSwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbXFKSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:51:44 -0400
Received: from server001.webpack.hosteurope.de ([80.237.130.9]:52228 "EHLO
	server001.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbXFKSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:51:39 -0400
From: Andi Drebes <lists-receive@programmierforen.de>
To: "Darren Jenkins" <darrenrjenkins@gmail.com>
Subject: Re: [KJ] Re: [PATCH] drivers/isdn/hisax: ARRAY_SIZE instead of sizeof
Date: Mon, 11 Jun 2007 20:51:11 +0200
User-Agent: KMail/1.9.5
Cc: "Jan-Benedict Glaw" <jbglaw@lug-owl.de>, kernel-janitors@lists.osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Karsten Keil" <kkeil@suse.de>
References: <200706101235.09578.lists-receive@programmierforen.de> <200706111120.07730.lists-receive@programmierforen.de> <82faac5b0706110525s56bade43rb24619b54687770d@mail.gmail.com>
In-Reply-To: <82faac5b0706110525s56bade43rb24619b54687770d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706112051.12407.lists-receive@programmierforen.de>
X-bounce-key: webpack.hosteurope.de;lists-receive@programmierforen.de;1181587899;566b3f51;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> I think what was meant here was to remove _all_ the macros that you
> assigned to the ARRAY_SIZE() macro.
Yes, absolutely. I overlooked the 'eg.' in Jan-Benedict's post. Sorry for that.

> If you look at the two advantages replacing code with the ARRAY_SIZE()
> macro has;
> 1. More readable/consistent code.
> 2. Faster compile times, because of less macros being defined.
ack. The arguments for the consistency that I mentioned in my last post
don't hold for a solution that removes all of the macros. So I'm absolutely
fine with a new patch that removes them all.
 
	Andi
