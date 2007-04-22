Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXDVDS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXDVDS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 23:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXDVDS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 23:18:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932212AbXDVDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 23:18:55 -0400
Date: Sat, 21 Apr 2007 20:18:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
Message-Id: <20070421201841.85717088.akpm@linux-foundation.org>
In-Reply-To: <87d51xtkmp.fsf@duaron.myhome.or.jp>
References: <20070419085750.GA2833@DervishD>
	<200704191352.06456.juergen127@kreuzholzen.de>
	<20070419141942.GF8287@DervishD>
	<87d51xtkmp.fsf@duaron.myhome.or.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007 07:42:22 +0900 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Recent Windows doesn't update ->free_clusters correctly. The "nofree"
> option ignores the ->free_clusters stored on FSINFO.

It'd be better to avoid the new mount option if possible: fatfs is used by
a *lot* of people who aren't particualrly expert, and we want to make things
easy for them.

Is there some way in which we can work out what's happened and fix it up?
