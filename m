Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbXF3Jyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbXF3Jyr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXF3Jyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:54:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbXF3Jyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:54:37 -0400
Date: Sat, 30 Jun 2007 02:54:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Dan Aloni <da-x@monatomic.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-Id: <20070630025425.59cbc299.akpm@linux-foundation.org>
In-Reply-To: <4685C549.3020602@intel.com>
References: <20070630023451.GA21593@localdomain>
	<4685C549.3020602@intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 19:51:53 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:

> > Some extensions to the popular E-Mail clients might be needed 
> > here. Also, a bot reading LKML would automatically send links 
> > about posted patches to the other mailing lists whenever 
> > someone forgets to add a CC.
> > 
> > Any comments?
> 
> an easier way to implement this is to add an extra field in the MAINTAINERS 
> file, something like below. All the contact info would stay the same, closely 
> where applicable and it would allow you to also specify specific files as well.

We already have that information in git.  Parse the git changelogs of the
affected files, find out who works on them.

Not that it'll help much, given the amnount of stuff which gets
mysteriously ignored even when the correct people are cc'ed...

(For extra giggles we could parse emailed oops and bug reports and add the
appropriate cc's there too.  Harder.)
