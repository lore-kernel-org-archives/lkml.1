Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYKXGN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYKXGN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKXGNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:13:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:53748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYKXGNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:13:16 -0500
Message-ID: <492A45E5.9010003@kernel.org>
Date: Mon, 24 Nov 2008 15:12:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>,
       Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
      needed.
References: <20081124035516.3465.66413.stgit@notabene.brown>    <20081124035530.3465.26724.stgit@notabene.brown>    <492A2B2B.7030606@kernel.org>    <18730.14324.830648.449469@notabene.brown>    <492A3CE6.4010206@kernel.org> <ca37dc6598bb5728423fd902ac5322f9.squirrel@neil.brown.name>
In-Reply-To: <ca37dc6598bb5728423fd902ac5322f9.squirrel@neil.brown.name>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 24 Nov 2008 06:12:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown wrote:
> Note that we already have 'release' in block_device_operations.  It is
> called on last close rather than last put.

Aieee... right.  How about release_disk() or disk_release()?

-- 
tejun
