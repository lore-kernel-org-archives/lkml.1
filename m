Return-Path: <linux-kernel-owner+w=401wt.eu-S1161304AbXCGHpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161304AbXCGHpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161309AbXCGHpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:45:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54809 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161304AbXCGHpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:45:51 -0500
Date: Tue, 6 Mar 2007 23:45:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: Jean Delvare <khali@linux-fr.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070306234529.3ce4cf3b.akpm@linux-foundation.org>
In-Reply-To: <1173253167.28531.41.camel@roc-desktop>
References: <1173164058.31825.16.camel@roc-desktop>
	<20070306214301.GA5590@martell.zuzino.mipt.ru>
	<1173247078.28531.24.camel@roc-desktop>
	<20070307075822.53e53c42.khali@linux-fr.org>
	<20070306231423.4231c99b.akpm@linux-foundation.org>
	<1173253167.28531.41.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 15:39:27 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> Thanks a lot, could you please give me a script just to kill this
> whitespace? So I can do it before sending you patches.


Is pretty simple:

#!/bin/sh
#
# Strip any trailing whitespace which a unified diff adds.
#

strip1()
{
	TMP=$(mktemp /tmp/XXXXXX)
	cp $1 $TMP
	sed -e '/^+/s/[ 	]*$//' < $TMP > $1
	rm $TMP
}

for i in $*
do
	strip1 $i
done


that'll be in
http://www.zip.com.au/~akpm/linux/patches/patch-scripts-0.20/patch-scripts-0.20.tar.gz
too
