Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYFCLF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYFCLF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYFCLFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:05:16 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:43802 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYFCLFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:05:15 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <200806021701.17076.arnd@arndb.de>
References: <200805311737.58991.arnd@arndb.de> <200806021613.15088.arnd@arndb.de> <8353.1212417209@jrobl> <200806021701.17076.arnd@arndb.de>
Date: Tue, 03 Jun 2008 20:04:41 +0900
Message-ID: <8486.1212491081@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann:
> Any writes should always just go to the top level. If the source file
> for link() exists on the top level, link should succeed even if a target
> exists on a lower level (given that the user has permissions to
> unlink that file), but should return EXDEV if the source comes from
> a lower level.

Then what will happen when a user builds a union by "empty tmpfs" +
"cramfs"? Following your design, link(2) becomes useless in stacking fs.

You may be considering to implement a new dynamic link library for
stacking.
Hmm, that is intersting. It may be worth to think.


Junjiro Okajima
