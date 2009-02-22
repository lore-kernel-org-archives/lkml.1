Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZBVT15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZBVT15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZBVT1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:27:45 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:48029 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBVT1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QrvIkiJK2gDoPfW9+0Pn0gCqWVQ/XaioZCsRvg6/L9VDRE1f+MgOdqKKaqFRqy+sCB
         QYIGu5C3QPx+0X+cS2NNj7qCMYg+y+Yh58MlPnEe6BDahA0pWvhr4YahUrYP0y1TUZ4Z
         ta1I0C3I5tUE0GH5mr/Q6HZ+0ykbFDeIxrkfM=
Message-ID: <49A1A72A.50102@gmail.com>
Date: Sun, 22 Feb 2009 20:27:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <20090222171032.GD6003@nowhere>
In-Reply-To: <20090222171032.GD6003@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.2.2009 18:10, Frederic Weisbecker wrote:
> I have some troubles with kmemcheck, so I give up for now.
> Well, by reading the kmemcheck documentation, it tells that there can be some false
> positives so...

This has nothing to do with kmemcheck.

> Since we are not sure this is a real bug, I'm not sure it would be interesting.

There is no false positive possibility with these checkers, so this is 
pretty much interesting, because it is a bug.
