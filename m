Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbZALFCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbZALFCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbZALFC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:02:26 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:43346 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbZALFCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:02:25 -0500
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 00:02:24 EST
From: Christian Couder <chriscool@tuxfamily.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: current git kernel has strange problems during bisect
Date: Mon, 12 Jan 2009 06:03:03 +0100
User-Agent: KMail/1.9.9
Cc: Pierre Habouzit <madcoder@debian.org>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200901111602.53082.borntraeger@de.ibm.com> <20090111230240.GA27489@artemis.corp> <200901120551.56791.chriscool@tuxfamily.org>
In-Reply-To: <200901120551.56791.chriscool@tuxfamily.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901120603.03977.chriscool@tuxfamily.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>
> Anyway it looks to me that this kind of problem could be avoided if one
> could "replace" some commits only when bisecting. In this case what could
> be done is that one could "replace" the commit where btrfs is merged with
> one commit that cuts off the btrfs history.

By the way, it possible right now to cut off the btrfs history in one's own 
repository using a graft. One don't need to wait for me to finish the 
replace stuff I am slowly working on. But on the other hand it will have 
all the restrictions of the current graft mechanism.

Regards,
Christian.
