Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYIWFMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYIWFMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYIWFLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:11:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1182 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYIWFLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:11:54 -0400
Subject: Re: [RFC] List of maintainers (draft #3)
From: Joe Perches <joe@perches.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ben Dooks <ben-linux@fluff.org>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080922194242.GA792@strlen.de>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>
	 <20080922081239.GA28726@strlen.de> <20080922091256.GH1916@fluff.org.uk>
	 <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com>
	 <48D7CA62.1020805@zytor.com>  <20080922194242.GA792@strlen.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 22 Sep 2008 22:10:33 -0700
Message-Id: <1222146633.18133.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 21:42 +0200, Uwe Kleine-König wrote:
> Continuing planning how to implement such an automation I found that
> git-send-email already has an option --cc-cmd=/path/to/some/program

I added cc-cmd to git-send-email.

> To go forward with how to specify a file <-> maintainer relation I
> suggest to standardize a field F in MAINTAINERS that specifies the
> associated files.

I did roughly the same thing last year with MAINTAINERS entries
and a script for patch submission.

http://lkml.org/lkml/2007/8/13/17

There were a few iterations before Linus said he didn't much
like the idea.

http://lkml.org/lkml/2007/8/13/1139

I still think it's useful and don't think a particularly
better way exists to generate this information.

I think the best way to manage this content is to separate
the monolithic MAINTAINERS into separate Maintainers/subsection
files (which would be automatically alphabetized) and to create
an aggregated MAINTAINERS file via Makefile.

If per directory .maintainers files are created, there'll
be roughly the same number of files.

http://lkml.org/lkml/2007/8/17/119

cheers, Joe

