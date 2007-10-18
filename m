Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbXJRUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbXJRUJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbXJRUJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:09:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60015 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbXJRUJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:09:07 -0400
Date: Thu, 18 Oct 2007 22:09:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Newall <david@davidnewall.com>
cc: jaroslav.sykora@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
In-Reply-To: <4717BBBB.6040205@davidnewall.com>
Message-ID: <Pine.LNX.4.64.0710182204050.22233@fbirervta.pbzchgretzou.qr>
References: <200710181721.09201.jara@sin.cvut.cz>
 <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr>
 <200710181907.58643.jara@sin.cvut.cz> <4717BBBB.6040205@davidnewall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 19 2007 05:32, David Newall wrote:
>
> The claim is wrong.  UNIX systems have traditionally allowed the
> superuser to create hard links to directories.  See link(2) for
> 2.10BSD
> <http://www.freebsd.org/cgi/man.cgi?query=link&sektion=2&manpath=2.10+BSD>.
> Having got that wrong throws doubt on the argument; perhaps a path
> can simultaneously be a file and a directory.

But hell will break lose if you allow hardlinking directories.

mkdir /tmp/a
ln /tmp/a /tmp/a/b

And you would not be able to rmdir /tmp/a/b because the directory is
not empty (it contains "b" [full path: /tmp/a/b/b]).
