Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYGOUW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYGOUW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYGOUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:22:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYGOUWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:22:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Avuton Olrich" <avuton@gmail.com>
Subject: Re: s2disk: system powers up again after power off
Date: Tue, 15 Jul 2008 22:24:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Martin Michlmayr" <tbm@cyrius.com>, linux-kernel@vger.kernel.org
References: <20080715124733.GA4111@deprecation.cyrius.com> <3aa654a40807150605r6d6206delcd903aac58f6291d@mail.gmail.com>
In-Reply-To: <3aa654a40807150605r6d6206delcd903aac58f6291d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807152224.19559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 of July 2008, Avuton Olrich wrote:
> On Tue, Jul 15, 2008 at 5:47 AM, Martin Michlmayr <tbm@cyrius.com> wrote:
> > When I use s2disk to suspend my HP 2510p notebook, it writes
> > everything to disk, and powers off... but after 2-3 seconds it often
> > powers on again.  This doesn't happen all the time but quite
> > frequently (definitely in the majority of cases).
> >
> > I believe I've never seen this when I use "halt" to power off the
> > machine (but I don't use halt very often).
> >
> > Any idea?
> 
> Ugh, this happens here too, this started occuring before 2.6.25 but
> every time I try to bisect it takes hours and I end up screwing up
> somewhere along the way, so I haven't had time to bisect this
> correctly.

Please try to put "shutdown method = shutdown" into the s2disk's configuration
file and see what happens in that case.

Thanks,
Rafael



