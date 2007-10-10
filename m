Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXJJRB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXJJRB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbXJJRBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:01:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16443 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbXJJRBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:01:19 -0400
Date: Wed, 10 Oct 2007 09:59:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cleaning up "make headers_install" for various architectures
Message-Id: <20071010095954.79c39a73.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain>
References: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 12:44:58 -0400 (EDT) Robert P. J. Day wrote:

>   the final example, parisc, just plain fails:
> 
> $ make ARCH=parisc headers_install
> /home/rpjday/k/git/scripts/gcc-version.sh: line 16: hppa-linux-gcc: command not found
> /home/rpjday/k/git/scripts/gcc-version.sh: line 17: hppa-linux-gcc: command not found
> /home/rpjday/k/git/arch/parisc/Makefile:39: *** Sorry, GCC v3.3 or above is required..  Stop.


Try
$ make CROSS_COMPILE="" CC=gcc ARCH=parisc headers_install

:(
---
~Randy
