Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZBVU1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZBVU1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZBVU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:27:42 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:39375 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZBVU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oRT+UxE7mPgbnGT18yv0PtaYcxWMUpwme7EbNK6SPVPWCQlB/j9wEIZDPI7+ktCehV
         05FnnaMItBfkaG6TK3CKyAwFTBpmcHa1fo0cybdWDNwpwRHh1wHqHTgNb4B2QayGWV3Y
         uP8fqgB2/vUGEfbHVTkOTRrpjLAh5gPp8K2mU=
Message-ID: <49A1B538.7090107@gmail.com>
Date: Sun, 22 Feb 2009 21:27:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <20090222171032.GD6003@nowhere> <49A1A72A.50102@gmail.com> <20090222194236.GA6060@nowhere> <20090222201821.GA21375@silver.sucs.org>
In-Reply-To: <20090222201821.GA21375@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.2.2009 21:18, Sitsofe Wheeler wrote:
> This case is more
> coarse as it only deals with allocation rather than initialisation (and
> if you scribble the same value as the poison pattern you go undetected)

This is false negative, yes.

> but I believe this is what Jiri is referring to as a "no false positive
> possibility" case - it's never right to write to unallocated memory.

Exactly, thanks.
