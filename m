Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYEWTMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYEWTMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYEWTLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:11:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48469 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754067AbYEWTLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:11:46 -0400
Date: Fri, 23 May 2008 19:58:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080523195822.5c6fe260@core>
In-Reply-To: <15168.1211558968@vena.lwn.net>
References: <20080523163956.6e93746c@core>
	<15168.1211558968@vena.lwn.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, drop me a pointer if you'd like this series pulled into the
> ever-growing bkl-removal tree.

Its a single big patch right now and I need to split it up further and
tidy it, plus see what the maintainers take and think. Once I've done
that I'd be in favour of actually patching ->ioctl out of the bkl-removal
tree and letting people fix the other architectures by neccessity ;)

Alan
