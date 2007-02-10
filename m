Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbXBJJ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbXBJJ4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXBJJ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:56:33 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:46037 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbXBJJ4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:56:32 -0500
Date: Sat, 10 Feb 2007 10:54:02 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <hansendc@us.ibm.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH 21/22] honor r/w changes at do_remount() time
In-Reply-To: <20070209152219.fa61d152.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0702101051440.1119@yvahk01.tjqt.qr>
References: <20070209225329.27619A62@localhost.localdomain>
 <20070209225344.93A75D35@localhost.localdomain> <20070209152219.fa61d152.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9 2007 15:22, Andrew Morton wrote:
>On Fri, 09 Feb 2007 14:53:44 -0800
>Dave Hansen <hansendc@us.ibm.com> wrote:
>
>> This is the core of the read-only bind mount patch set.
>
>Who wants read-only bind mounts, and for what reason?

And another case could be, that some application modifies ~/.xyz, but the user
(with root's help) does not want that:

  mount --bind -r ~/.xyz ~/.xyz

chmoding out the w bits does not always work, as programs might tamper with the
permissions of ~/.xyz itself... so a ro mount seems to be best.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
