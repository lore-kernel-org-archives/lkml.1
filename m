Return-Path: <linux-kernel-owner+w=401wt.eu-S934222AbXEKXXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbXEKXXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761687AbXEKXXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:23:31 -0400
Received: from khc.piap.pl ([195.187.100.11]:41287 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbXEKXX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:23:29 -0400
To: Rene Herman <rene.herman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rusty Russell <rusty@rustcorp.com.au>,
       bunk@stusta.de, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, marcel@holtmann.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
References: <4643BDF2.9030105@gmail.com>
	<20070511114605.4c2698ec@the-village.bc.nu>
	<46447ABF.3000004@gmail.com>
	<20070511154009.50c8bae0@the-village.bc.nu>
	<4644A637.1060507@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 12 May 2007 01:23:27 +0200
In-Reply-To: <4644A637.1060507@gmail.com> (Rene Herman's message of "Fri, 11 May 2007 19:21:59 +0200")
Message-ID: <m3hcqj6j2o.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@gmail.com> writes:

> /* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>]
>
> After my trivial patch, it says:
>
> /* Author, ideally of form NAME[, NAME]*[ and NAME] */

I think I would put something like this:

/* Author, of form NAME[, NAME]*[ and NAME]
 * If you have a permanent email address and are prepared for
   maintaining/supporting the module, you may want to provide
   the address as well */

The wording isn't the best I suppose.

I.e., the change would mean providing the address is not strictly
required and the person should think when adding it, that's all.
-- 
Krzysztof Halasa
