Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZKCWxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZKCWxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZKCWxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:53:46 -0500
Received: from broadrack.ru ([195.178.208.66]:50406 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZKCWxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:53:45 -0500
Date: Wed, 4 Nov 2009 01:53:43 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dst: Fix parentheses
Message-ID: <20091103225343.GA9145@ioremap.net>
References: <4AF0B35A.8080400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF0B35A.8080400@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 11:48:58PM +0100, Roel Kluin (roel.kluin@gmail.com) wrote:
> `|' has a higher precedence than `?' so since MSG_WAITALL is
> defined 0x100, MSG_MORE was always written to the msg_flag.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Looks good, thank you!
Andrew, please queue it into the appropriate tree.

-- 
	Evgeniy Polyakov
