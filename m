Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYLONK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYLONK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYLONKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:10:48 -0500
Received: from stinky.trash.net ([213.144.137.162]:56031 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYLONKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:10:47 -0500
Message-ID: <4946574F.5080107@trash.net>
Date: Mon, 15 Dec 2008 14:10:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: coreteam@netfilter.org, netfilter@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [netfilter-core] [PATCH] netfilter: remove padding from struct
 xt_match on 64bit	builds
References: <1229089190.2921.7.camel@castor.localdomain>
In-Reply-To: <1229089190.2921.7.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:
> reorder struct xt_match to remove 8 bytes of padding and make its size
> 128 bytes.
> 
> This saves a small amount of data space in each of the xt netfilter
> modules and fits xt_match in one 128 byte cache line.

Applied, thanks.
