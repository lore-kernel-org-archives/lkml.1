Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbXIVTZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbXIVTZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXIVTZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:25:07 -0400
Received: from quechua.inka.de ([193.197.184.2]:44966 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbXIVTZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:25:06 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: memset as memzero
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20070922124659.741cca42@laptopd505.fenrus.org>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1IZAbA-0001uz-00@calista.eckenfels.net>
Date: Sat, 22 Sep 2007 21:25:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070922124659.741cca42@laptopd505.fenrus.org> you wrote:
> it doesn't add value.... memset with a constant 0 is just as fast
> (since the compiler knows it's 0) than any wrapper around it, and the
> syntax around it is otherwise the same.

it would however allow easier changing if you need to add a page cleaning
system (for example new architecture which has support for it). On the other
hand, is memset used for anything else than zero filling or redzone
"filling"?

Gruss
Bernd
