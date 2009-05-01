Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZEAMTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZEAMTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZEAMTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:19:11 -0400
Received: from www17.your-server.de ([213.133.104.17]:43147 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZEAMTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:19:11 -0400
Subject: Re: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements,
 faster than Bkl based scheme
From: Thomas Meyer <thomas@m3y3r.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>, J@pimp.vs19.net
In-Reply-To: <20090501053540.GC5983@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
	 <20090501053540.GC5983@elte.hu>
Content-Type: text/plain
Date: Fri, 01 May 2009 14:18:36 +0200
Message-Id: <1241180316.3783.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 01.05.2009, 07:35 +0200 schrieb Ingo Molnar:
> 
> I've pulled it and have also merged -rc4 into the kill-the-BKL tree, 
> which can picked up from here:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL
> 
> So for comparative benchmarking, vanilla v2.6.30-rc4 (which has the 
> BKL) can be compared against latest kill-the-BKL

Hi,

Kernel gets soft-locked-up in somewhere in initrd:

See
http://m3y3r.de/bilder/img_0524.jpg
http://m3y3r.de/bilder/img_0525.jpg
http://m3y3r.de/bilder/img_0526.jpg
http://m3y3r.de/bilder/img_0527.jpg
http://m3y3r.de/bilder/img_0528.jpg
http://m3y3r.de/bilder/img_0529.jpg

config is:
http://m3y3r.de/bilder/config-2.6.30-rc4-ktb

greets
thomas


