Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZLEU1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZLEU1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZLEU1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:27:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57315 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757906AbZLEU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:27:07 -0500
Date: Sat, 5 Dec 2009 20:28:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Lutomirski <luto@mit.edu>, miklos@szeredi.hu,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
In-Reply-To: <E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe alan was worried about the O_NODE | O_RDWR, etc. case?  That
> simply doesn't make any sense for special files.

I am concerned primarily about the lack of ability to get rid of such a
handle in a controlled fashion. The udev/device unload case is simply one
obvious way to exploit it.

I still don't believe O_NODE makes sense without revoke(), and even then
needs huge amounts of care on the device side of things.
