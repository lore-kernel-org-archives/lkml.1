Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYFBRJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYFBRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYFBRJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:09:18 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35272 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbYFBRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:09:17 -0400
Date: Mon, 2 Jun 2008 13:09:16 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080602170916.GD16164@csclub.uwaterloo.ca>
References: <20080601161510.GA26854@enneenne.com> <20080602075113.60d0fdf8@core> <20080602092551.GC26854@enneenne.com> <20080602150257.54692f35@core> <20080602145603.GG26854@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602145603.GG26854@enneenne.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 04:56:03PM +0200, Rodolfo Giometti wrote:
> I prefere avoid the if clause for getnstimeofday() since each
> instruction delay may decrease time precision, so:

Not if the delay is always constant.  That you can adjust for.  You
already have to adjust for cable length and such for your GPS, so
adjusting for a fixed delay for a conditional is no big deal.

Of course if you have to check of the DCD changed, that may not be
constant.  A check for whether this device currently has anyone that
wants the timestamp though should be a constant time.

-- 
Len Sorensen
