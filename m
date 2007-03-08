Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbXCHHgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbXCHHgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932949AbXCHHgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:36:52 -0500
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:3786 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932932AbXCHHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:36:52 -0500
Date: Thu, 8 Mar 2007 08:35:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <bryan.wu@analog.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070308083547.38908b6c.khali@linux-fr.org>
In-Reply-To: <20070306234529.3ce4cf3b.akpm@linux-foundation.org>
References: <1173164058.31825.16.camel@roc-desktop>
	<20070306214301.GA5590@martell.zuzino.mipt.ru>
	<1173247078.28531.24.camel@roc-desktop>
	<20070307075822.53e53c42.khali@linux-fr.org>
	<20070306231423.4231c99b.akpm@linux-foundation.org>
	<1173253167.28531.41.camel@roc-desktop>
	<20070306234529.3ce4cf3b.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 23:45:29 -0800, Andrew Morton wrote:
> On Wed, 07 Mar 2007 15:39:27 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> 
> > Thanks a lot, could you please give me a script just to kill this
> > whitespace? So I can do it before sending you patches.
> 
> 
> Is pretty simple:
> 
> #!/bin/sh
> #
> # Strip any trailing whitespace which a unified diff adds.
> #
> 
> strip1()
> {
> 	TMP=$(mktemp /tmp/XXXXXX)
> 	cp $1 $TMP
> 	sed -e '/^+/s/[ 	]*$//' < $TMP > $1
> 	rm $TMP
> }
> 
> for i in $*
> do
> 	strip1 $i
> done
> 
> 
> that'll be in
> http://www.zip.com.au/~akpm/linux/patches/patch-scripts-0.20/patch-scripts-0.20.tar.gz
> too

Alternatively, you can use quilt [1] to manage your patches and enable
the --strip-trailing-whitespace option by default.

[1] http://savannah.nongnu.org/projects/quilt/

-- 
Jean Delvare
