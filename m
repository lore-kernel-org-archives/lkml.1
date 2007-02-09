Return-Path: <linux-kernel-owner+w=401wt.eu-S1945967AbXBIBSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945967AbXBIBSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945974AbXBIBSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:18:32 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27020 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945967AbXBIBSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:18:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=NSJRJHn1g9zLH1b7a4guppVn0MvWJV7SPQ4JymnE6ImhVRh+mIGG0AINVzNlWOAeZ
	I6ODX6qARH5OcY86BEFLg==
Date: Thu, 8 Feb 2007 17:18:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081705300.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081715020.30410@chino.kir.corp.google.com>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081643280.30166@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081705300.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Linus Torvalds wrote:

> Even gcc DOES DIFFERENT THINGS! Have you even read the docs?
> 
> 	By default it is treated as signed int but this may be changed by 
> 	the -funsigned-bitfields option.
> 

Yes, I read the 4.1.1 docs:

	By default, such a bit-field is signed, because this is
	consistent: the basic integer types such as int are signed
	types.

That is the whole basis for my argument, when you declare something "int," 
most programmers would consider that to be SIGNED regardless of whether it 
is 32 bits, 13 bits, or 1 bit.

No doubt it is configurable because of the existance of brain-dead 
compilers that treat them as unsigned.
