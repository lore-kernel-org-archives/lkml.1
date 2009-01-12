Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZALDeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZALDeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZALDeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:34:08 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2467 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZALDeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:34:07 -0500
X-Greylist: delayed 824 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 22:34:06 EST
Date: Mon, 12 Jan 2009 04:19:57 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Warren Turkal <wt@penguintechs.org>
cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Diego Elio 'Flameeyes' Petten?" <flameeyes@gmail.com>
Subject: Re: 2.6.29 -mm merge plans
In-Reply-To: <e37d376a0901061526s5d571febu2eb9758050506442@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901081255580.17013@localhost.localdomain>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> 
 <20090106225744.GA10553@infradead.org>  <20090106151747.c640dfd4.akpm@linux-foundation.org>
  <20090106231958.GA30271@infradead.org> <e37d376a0901061526s5d571febu2eb9758050506442@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 6 Jan 2009, Warren Turkal wrote:

(Sorry for the delay.)

> I have a drive at home with the condition. So empirically, it can happen.

One problem is that there is no explanation how it happened.
The other problem is that in the Apple driver or tools I haven't found an 
equivalent (unless you disable journaling completely), there is simply no 
special handling of a zero in this field.
I find it more likely that some repair tool simply sets this field to 
zero, so it forces the OS X driver to reinitialize the journal file. It 
might help to look at the last_mount field to have some idea who accessed 
the volume last.
So your first patch is kinda trivial, although most of comment isn't 
needed and is irrelevant to the patch itself, however I don't see a reason
to apply the second patch.

bye, Roman
