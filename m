Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbYD3Ufm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbYD3Ufm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765585AbYD3UfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:35:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765463AbYD3UfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:35:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "SL Baur" <steve@xemacs.org>
X-Fcc: ~/Mail/linus
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andres Salomon" <dilinger@queued.net>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
In-Reply-To: SL Baur's message of  Wednesday, 30 April 2008 13:32:52 -0700 <ed10ee420804301332n5fb72f3jb9bdea03aa313fad@mail.gmail.com>
References: <20080429183531.GB19652@uranus.ravnborg.org>
	<20080429172402.14d7d40b@ephemeral>
	<ed10ee420804300345r5d4566d2uff5c3f49f1c15107@mail.gmail.com>
	<20080430080134.60346a12.randy.dunlap@oracle.com>
	<ed10ee420804301332n5fb72f3jb9bdea03aa313fad@mail.gmail.com>
X-Windows: the defacto substandard.
Message-Id: <20080430203510.AEE7426FA04@magilla.localdomain>
Date: Wed, 30 Apr 2008 13:35:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Eg. `make K=HPxw4300.config ...' would have "-HPxw4300" appended
> to EXTRAVERSION.  Maybe this doesn't make sense any more, but it
> was once something I wanted very much.

We have "echo .foo > localversion" or CONFIG_LOCALVERSION=.foo for that.
Maybe what you would like is a variable on that make command line to
magically set CONFIG_LOCALVERSION with less typing.


Thanks,
Roland
