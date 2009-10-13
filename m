Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZJMMhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZJMMhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbZJMMhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:37:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54007 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514AbZJMMhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:37:17 -0400
Message-ID: <4AD47454.9010302@canonical.com>
Date: Tue, 13 Oct 2009 14:36:36 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Kusanagi Kouichi <slash@ma.neweb.ne.jp>,
       "David S. Miller" <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 29/37] tun: Return -EINVAL if neither
 IFF_TUN nor IFF_TAP is set.
References: <20091009233411.852013234@mini.kroah.org> <20091009233439.813028112@mini.kroah.org>
In-Reply-To: <20091009233439.813028112@mini.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as a note (as I am too late for proper review), this patch is doing 
nothing in the case of 2.6.31 as it lacks the previous commit to break things. 
But it does not hurt either as it is functionally the same as before.

-Stefan
