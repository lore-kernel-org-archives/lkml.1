Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZC0SKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZC0SKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbZC0SKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:10:39 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60733 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZC0SKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:10:38 -0400
Message-ID: <49CD1622.8040508@s5r6.in-berlin.de>
Date: Fri, 27 Mar 2009 19:08:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] firedtv: wrong types in printk
References: <20090326214101.18485.58960.stgit@localhost.localdomain>
In-Reply-To: <20090326214101.18485.58960.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> --- a/drivers/media/dvb/firewire/firedtv-avc.c
> +++ b/drivers/media/dvb/firewire/firedtv-avc.c
> @@ -150,7 +150,7 @@ static void debug_fcp(const u8 *data, size_t length)
>  		subunit_type = data[1] >> 3;
>  		subunit_id = data[1] & 7;
>  		op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
> -		printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
> +		printk(KERN_INFO "%ssu=%x.%x l=%Zd: %-8s - %s\n",
>  		       prefix, subunit_type, subunit_id, length,
>  		       debug_fcp_ctype(data[0]),
>  		       debug_fcp_opcode(op, data, length));

This is already fixed in -next via linux1394-2.6.git.  (1394 git pull
request follows later today.)
-- 
Stefan Richter
-=====-==--= --== ==-==
http://arcgraph.de/sr/
