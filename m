Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZJLFU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZJLFU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZJLFU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:20:59 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:37294 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZJLFU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:20:58 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union mounts/writable overlays design 
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       Arnd Bergmann <arnd@arndb.de>, Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091011014339.GB12667@shell>
References: <20091001145547.GA29152@shell> <15604.1254497442@jrobl> <20091011014339.GB12667@shell>
Date: Mon, 12 Oct 2009 14:19:14 +0900
Message-ID: <7347.1255324754@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> In writable overlays, every directory will be copied up to the top
> writable overlay, so /u and /u/usr will both have the same st_dev.
> The copy up happens on lookup, so a stat() will trigger this copy up.
> A directory and a regular file in it will have different st_dev's,
> though.  Can you foresee any problems with that?

You're right.
I was confused with another implementation of UnionMount, sorry.
I think I had to sleep well.


J. R. Okajima
