Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbZCPNH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbZCPNH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZCPNHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:07:12 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:35977 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZCPNHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:07:11 -0400
Message-ID: <49BE4EF6.3030406@grupopie.com>
Date: Mon, 16 Mar 2009 13:07:02 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: =?UTF-8?B?TWljaGFlbCBCw7xrZXI=?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <20090304224310.GA29043@electric-eye.fr.zoreil.com> <49B5066D.1030309@grupopie.com>
In-Reply-To: <49B5066D.1030309@grupopie.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui Santos wrote:
> If I get any further I'll let you know.
>
> Regards,
> Rui Santos
>
>   
I Finally ended up the big bisect operation. The commit responsible for
this issue is commit
b726e493e8dc13537d1d7f8cd66bcd28516606c3
labeled
'r8169: sync existing 8168 device hardware start sequences with vendor
driver'

With that patch removed, I  was able to get a sustained 40MB/s+ on a
20GB ftp transfer. I wasn't able to do it with the specified patch applied.
Just as a side note, I was never able to reproduce it on a 100MBit
connection, only on a full 1GBit one...

However this patch will not reverse on the current kernel.

What do you think the next step should be ?
As usual, if you need any testing, please do let me know.

Regards,
Rui Santos

