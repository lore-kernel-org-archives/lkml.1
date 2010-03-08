Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0CHRiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:38:01 -0500
Received: from ppp173-197.broadband.gorge.net ([209.216.173.197]:38633 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754550Ab0CHRh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:37:57 -0500
Date: Mon, 8 Mar 2010 17:30:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
In-Reply-To: <20100308094647.GA14268@elte.hu>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In that sense it appears to me that it's pretty much a universal truth that 
> 'pathnames' are a far more fitting abstraction to any 'human based security 

Ingo - just about all the serious security work disagrees with you.
Pathnames are references to objects and keep changing. What matters is
the object itself. This is also how Unix has always worked

Imagine if chmod applied to the path not the inode ?

> Also, why was/(is?) AppArmor considered as a 'hostile competitor' 

I don't believe it was. It was perceived as a technical failure, and then
the file system people shredded the bits the security folks didn't.

There are certain things path name bases security works quite nicely for,
primarily systems that have no concept of links. It's why it works
ok-ish for httpd but for the general case nobody has ever really made it
work properly.

Alan
