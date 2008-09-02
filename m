Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbYIBMZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbYIBMZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYIBMZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:25:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYIBMZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:25:25 -0400
Message-ID: <48BD3031.3090905@kernel.org>
Date: Tue, 02 Sep 2008 14:23:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org> <48BD1BA5.1020604@hp.com> <48BD1E30.8040602@kernel.org> <20080902122006.GN15123@agk.fab.redhat.com>
In-Reply-To: <20080902122006.GN15123@agk.fab.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Sep 2008 12:24:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alasdair G Kergon wrote:
> On Tue, Sep 02, 2008 at 01:06:24PM +0200, Tejun Heo wrote:
>> Well, dev_t is 32bits and MINORBITS is 20.  So, major 12 bits, minor 20
>> bits, so 4 characters for major, 7 characters for minor.
>  
> Upstream libdevmapper CVS patched - will appear in next release (1.02.28).

Alright, thanks.  What about the /proc/devices one?  Would adding an
entry help?  I'm kind of lost /proc/devices.  It's now mostly
non-functional legacy stuff we've been carrying around.  Is it
deprecated or do we intend to keep it around forever?

Ooh.. which also reminds me that I forgot to reserve the major number w/
lanana.  Will do that.

Thanks.

-- 
tejun
