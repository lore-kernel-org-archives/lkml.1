Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIRNmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIRNmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYIRNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:42:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34937 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYIRNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:42:11 -0400
Date: Thu, 18 Sep 2008 09:41:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: j@w1.fi, jouni.malinen@atheros.com, alex.williamson@hp.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking (WEXT events and 64/32 compat)
Message-ID: <20080918134112.GB4552@tuxdriver.com>
References: <20080908.204323.04156464.davem@davemloft.net> <20080909040525.GA26151@hostap.isc.org> <20080917191128.GA23239@hostap.isc.org> <20080917.131133.135282530.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917.131133.135282530.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 01:11:33PM -0700, David Miller wrote:
> From: Jouni Malinen <j@w1.fi>
> Date: Wed, 17 Sep 2008 12:11:28 -0700
> 
> > Would it be acceptable to ever enable use of IWEVASSOCREQIE /
> > IWEVSSOCRESPIE in kernel if the workaround were available in new
> > wpa_supplicant versions? Or should we try to add a new WEXT event
> > type that uses fixed size for the length field and then replace the old
> > IWEVCUSTOM with the new type since IWEVCUSTOM does not work with
> > 64/32-bit case (wpa_supplicant just knows how to avoid processing that
> > bogus event data)?
> 
> Moving to a new event with a strictly sized datastructure, instead of
> one that has variable sized members like pointers and crap which are
> impossible to compat layer'ify, is indeed my preference.
> 
> But in that case, we might as well make nl80211 usable instead.

This is, of course, my opinion as well.

John
-- 
John W. Linville
linville@tuxdriver.com
