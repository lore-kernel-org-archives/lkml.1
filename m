Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYCLMjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYCLMjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbYCLMjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:39:17 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:26103 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751351AbYCLMjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:39:17 -0400
Date: Wed, 12 Mar 2008 15:39:13 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] gpiolib: add __must_check attribute to the gpiochip_add function
Message-ID: <20080312123913.GA13266@localhost.localdomain>
Reply-To: avorontsov@ru.mvista.com
References: <20080311174129.GC12397@localhost.localdomain> <200803111402.38671.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200803111402.38671.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 01:02:38PM -0800, David Brownell wrote:
> On Tuesday 11 March 2008, Anton Vorontsov wrote:
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> I'm curious why you want to change this.   When it fails, a
> KERN_ERR message is emitted ...

Ah, I missed that the gpiochip_add() issuing pr_err(), not pr_debug().

So, please just ignore that patch. Though, printing errors from the
generic functions is confusing, you never know when your code or the
function you call should print the error. And usually generic functions
tend to be silent...

-- 
Anton Vorontsov
email: cboumailru@gmail.com
irc://irc.freenode.net/bd2
