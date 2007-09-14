Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXINQoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXINQoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbXINQoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:44:10 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:63387 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbXINQoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:44:09 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Chris Wedgwood <cw@f00f.org>
Cc: LKML <linux-kernel@vger.kernel.org>, davej@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
References: <20070912232534.GA26868@puku.stupidest.org>
Date: Fri, 14 Sep 2007 18:44:04 +0200
In-Reply-To: <20070912232534.GA26868@puku.stupidest.org> (Chris Wedgwood's
	message of "Wed, 12 Sep 2007 16:25:34 -0700")
Message-ID: <87ir6dqjsb.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wedgwood <cw@f00f.org> writes:

> This is a somewhat rough first-pass at making a 'minimal tree'
> installation target.  This installs a partial source-tree which you
> can use to build external modules against.  It feels pretty unclean
> but I'm not aware of a much better way to do some of this.
>
> This patch works for me, even when using O=<buildtree>.  It probably
> needs further cleanups.
>
> Comments?

Ever looked at the debian packages and how they do it? They even split
out common files and specific files from the kernel build. Saves some
space if you build multiple flavours of the same kernel version.

MfG
        Goswin
