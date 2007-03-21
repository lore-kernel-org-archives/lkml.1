Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbXCUW3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbXCUW3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933886AbXCUW3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:29:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:52898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbXCUW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:29:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BLK_DEV_MD with CONFIG_NET
Date: Wed, 21 Mar 2007 23:30:24 +0100
User-Agent: KMail/1.9.6
Cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <20070320200538.5270d636.randy.dunlap@oracle.com> <20070320.202621.74740974.davem@davemloft.net> <20070321120246.GB18195@uranus.ravnborg.org>
In-Reply-To: <20070321120246.GB18195@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703212330.24502.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aoeZcgPI95+xfp9unvL9bVZjG8FBwojALyRI
 B3l6Hu4DL+ud8bYAchwHR+PxA0kzY+GIFyYEaFGZYBzkWvAgB6
 /iC1MurXGOzNwalmr6wVg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 13:02:46 Sam Ravnborg wrote:
> > Anything which is every exported to modules, which ought to
> > be the situation in this case, should be obj-y not lib-y
> > right?
>
> That is also my understanding of lib-y - I should update makefiles.txt
> to reflect this..

Strictly speaking, it could well be obj-m instead of obj-y if it
is _only_ used by modules. OTOH, it makes the Makefile a lot simpler
to not optimize for this case.

	Arnd <><
