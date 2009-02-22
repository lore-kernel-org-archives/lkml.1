Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZBVV4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZBVV4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZBVV4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:56:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:20260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZBVV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:56:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vMwu6lTBi4C7iFo1O+BoRdPt1LM7mch/Ro33ou4KMATMVfQyj9ebWXtYuwdF9b4BWu
         GkH78pZjgPu8O9X16hkplrLN9PDDYYnW0+DCSSxt4ojbWTBmJtFHnBGVxg0CGcheJOmG
         VK+pLxlTEO50A/SsM6G1a6o6PBADjZ76XYOn8=
Message-ID: <49A1CA01.9030501@gmail.com>
Date: Sun, 22 Feb 2009 22:56:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org>
In-Reply-To: <20090222170201.GA27360@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.2.2009 18:02, Sitsofe Wheeler wrote:
> On Sun, Feb 22, 2009 at 03:47:44PM +0100, Frederic Weisbecker wrote:
>> Looks like it happens with ath5k driver.
>> Well, I have an atheros card, so I'm testing it.
>
> Good luck! I've just switched to a different location (with faster wifi
> and more single network access points ) and I've been totally unable to
> reproduce this warning.

Well, maybe we should try to reproduce with jumbo packets sent to the 
ath5k receiver, since I think it (1) is not very much test-covered code 
(2) appears to be related.

Could you append lspci -vvnnxxx of your adapter? Better along with 
ath_info[1] output.

[1] svn co http://svn.madwifi-project.org/ath_info/trunk ath_info
