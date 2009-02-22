Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbZBVXYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbZBVXYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbZBVXU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:20:58 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:52231 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbZBVXUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hcv8oCe7aX9AUaPP1ZEZo7Ry0/VPjzgip4lhe1NmSLeoKYJsJE7McecrkNpv1vmgiA
         cz7HyoWxwdYnTKjPuohD3A1RM84/m4BGuCxwag89E3bkys9d+vZp6qV9zx/K83T/QIMz
         ah5fsWspxCwIA2bb6FlkWn0XfXoKe2lupylBE=
Message-ID: <49A1DDD2.7040706@gmail.com>
Date: Mon, 23 Feb 2009 00:20:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com>
In-Reply-To: <49A1CA01.9030501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.2.2009 22:56, Jiri Slaby wrote:
> Well, maybe we should try to reproduce with jumbo packets sent to the
> ath5k receiver, since I think it (1) is not very much test-covered code
> (2) appears to be related.

According to the spec I have for older chip, there is not `done' flag 
set for descriptors which have `more' flag set. We handle this wrongly. 
Am I looking correctly, Nick, Luis, Bob?

I still don't see what could have caused this though.
