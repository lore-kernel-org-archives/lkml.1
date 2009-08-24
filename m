Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZHXOyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZHXOyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZHXOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:54:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZHXOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:54:10 -0400
Date: Mon, 24 Aug 2009 10:54:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dick Streefland <dick@streefland.net>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: manual merge of the kconfig tree with the kbuild
 tree
In-Reply-To: <20090824083433.GA6147@streefland.net>
Message-ID: <alpine.DEB.2.00.0908241052420.7587@gandalf.stny.rr.com>
References: <20090824113226.b61cccc6.sfr@canb.auug.org.au> <20090824083433.GA6147@streefland.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 24 Aug 2009, Dick Streefland wrote:

> On Monday 2009-08-24 11:32, Stephen Rothwell wrote:
> | Today's linux-next merge of the kconfig tree got conflicts in
> | scripts/extract-ikconfig between commit
> | 692d21e03cfc740684639b019ce9ad708930eb47 ("kconfig: simplification of
> | scripts/extract-ikconfig") from the kbuild tree and commits
> | fd3132d5815bf72aeec7d5ad87161b4831f8e48c ("kconfig: add check if end
> | exists in extract-ikconfig") and 6be51ffc1791b72d11cef9bb0a578fe8c5d64c6a
> | ("kconfig: have extract-ikconfig read ELF files") from the kconfig tree.
> | 
> | It looks like the kbuild patch obsoletes the first of the kconfig patches
> | and may obsolete the second.  I used the kbuild version for now, but
> | invite advice.
> 
> My simplified script that you merged from the kbuild tree will also
> extract config information from ELF files. So both patches from the
> kconfig tree are not needed anymore.

OK what is the proper way to resolve this, before sending anything off to 
Linus?  Should I pull in Dick's tree and resolve the conficts myself, and 
let you repull? Or is something else recommended?

Thanks,

-- Steve

