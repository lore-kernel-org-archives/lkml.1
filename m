Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbXGHFuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbXGHFuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 01:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXGHFuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 01:50:14 -0400
Received: from ozlabs.org ([203.10.76.45]:36893 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXGHFuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 01:50:13 -0400
Subject: maps2-move-the-page-walker-code-to-lib.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 15:49:56 +1000
Message-Id: <1183873796.6005.269.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt wrote:
> This lets it get shared outside of proc/ and linked in only when needed.

Erk, this really belongs in the mm dir.  You can use "lib-y +=
pagewalk.o" there, and it seems to work as well as doing it in lib.

Cheers,
Rusty.

