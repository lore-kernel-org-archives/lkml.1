Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXD1VD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXD1VD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXD1VD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:03:26 -0400
Received: from khc.piap.pl ([195.187.100.11]:34647 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXD1VDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:03:25 -0400
To: Rene Herman <rene.herman@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <20070404170016.453d26f1@the-village.bc.nu>
	<4613D492.2070404@gmail.com> <462C7D74.60003@gmail.com>
	<1177327476.17026.75.camel@localhost.localdomain>
	<Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
	<462CA764.5080401@gmail.com>
	<20070425181856.42fcfeb4.akpm@linux-foundation.org>
	<463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de>
	<20070426084143.1d973c71.randy.dunlap@oracle.com>
	<20070426155205.GN3468@stusta.de> <4631219D.4060402@gmail.com>
	<463265D4.1010703@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 28 Apr 2007 23:03:23 +0200
In-Reply-To: <463265D4.1010703@gmail.com> (Rene Herman's message of "Fri, 27 Apr 2007 23:06:28 +0200")
Message-ID: <m3abwsciuc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@gmail.com> writes:

[MODULE_AUTHOR]

> Given that the email address is all that I want to
> supress; how about just deleting that instead?

Makes sense at least WRT the "problematic" modules.

include/linux/module.h says:

/* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

I think we should get rid of the "EMAIL" comments:

/* Author, ideally of form FULL NAME [, FULL NAME ]*[ and FULL NAME] */
#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)


I'd rather let the respective maintainers/authors take care of "their"
MODULE_AUTHOR entries (though the removal seems sane for me personally).

> I'd prefer that; unlike the name, the adress is information that can
> get outdated

Right

> and moreover, removing the address not only from the
> modinfo output but from the source directly means it can't be mistaken
> for a contact address there either.

Sure.
-- 
Krzysztof Halasa
