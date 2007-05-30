Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbXE3XSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbXE3XSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXE3XR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:17:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44719
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbXE3XR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:17:58 -0400
Date: Wed, 30 May 2007 16:18:11 -0700 (PDT)
Message-Id: <20070530.161811.108115564.davem@davemloft.net>
To: adaplas@gmail.com
Cc: adobriyan@gmail.com, akpm@linux-foundation.org, teanropo@jyu.fi,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, apw@shadowen.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: tty-related oops in latest kernel(s)?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1180566886.4570.14.camel@daplas>
References: <20070530090945.ab9d51d9.akpm@linux-foundation.org>
	<20070530180428.GA5731@martell.zuzino.mipt.ru>
	<1180566886.4570.14.camel@daplas>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Antonino A. Daplas" <adaplas@gmail.com>
Date: Thu, 31 May 2007 07:14:46 +0800

> Yes, 256 is too many. the pseudo_palette is used for the 16-color
> console only.

Many many drivers allocate 256 entries, just FYI :-)  They
all should be fixed up I guess.
