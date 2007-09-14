Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbXINJtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbXINJtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXINJtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:49:12 -0400
Received: from barikada.upol.cz ([158.194.242.200]:37526 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXINJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:49:10 -0400
Date: Fri, 14 Sep 2007 12:04:31 +0200
To: Chris Wedgwood <cw@f00f.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       davej@redhat.com, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070914100431.GX475@flower.upol.cz>
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org> <20070913185753.GA9259@puku.stupidest.org> <20070913191938.GD27146@uranus.ravnborg.org> <20070913201727.GW475@flower.upol.cz> <20070913200506.GA11582@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913200506.GA11582@puku.stupidest.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 01:05:06PM -0700, Chris Wedgwood wrote:
> On Thu, Sep 13, 2007 at 10:17:27PM +0200, Oleg Verych wrote:
> 
> > That particular one-line `ALTARCH := i386' of course can be matched
> > simpler, because there's only *one* (as written above) whitespace and no
> > make's assignment variations,
> 
> The goal is to extract the RHS from ALTARCH := ...

printf "C=i386\n  ALTARCH =   i386
ALTARCH= i386
ALTARCH :=i386
A=i386
ALTARCH := i386
ALTARCH?=i386
" | sed -n '
/^[[:blank:]]*ALTARCH[^?]*=/{
    /[[:blank:]:]*=[[:blank:]]*i386[[:blank:]]*$/{
        s_.*_i386_;=;p;
    }
}'

Maybe this one then, to much as much valid assigments as possible :)
____
