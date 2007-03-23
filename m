Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbXCWOgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbXCWOgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXCWOgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:36:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38142 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbXCWOgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:36:07 -0400
Date: Fri, 23 Mar 2007 14:36:05 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-ID: <20070323143605.GA4095@ftp.linux.org.uk>
References: <4603DE86.1090009@slax.org> <20070323151956.1ac6a47b.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323151956.1ac6a47b.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 03:19:56PM +0100, Eric Dumazet wrote:
> On Fri, 23 Mar 2007 15:04:54 +0100
> Tomas M <tomas@slax.org> wrote:
> 
> > I posted this yesterday but it seems people didn't understand the real 
> > goal of my patch. So I will explain once more again:
> > 
> > This is a bugfix for loop.c block driver, as it currently allocates more 
> > memory then it needs, without any further use.
> 
> Well... changing the Changelog wont help I'm afraid.
> 
> I cooked the following patch (untested), feel free to test it.

Please, get the cleanup into saner shape.  This is too ugly.
