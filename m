Return-Path: <linux-kernel-owner+w=401wt.eu-S934591AbZARR7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591AbZARR7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764465AbZARR7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:59:05 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:55436 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761556AbZARR7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=WloR0ItCYVb1E1d95AmvLQRvb6pvsioAYbkSec5g7/ARwEHjes3rjOikBJBjIvpfb4
         dfosce3RZ/+jM7/f/ztmwEFG4Mzd3vIvlwwm2bJOvneF9vLE9UzojiV6l/6IdQnCY8E+
         pd04zzBifT6k36cNkfNFl07DNbGSzZeUD+7Jc=
Date: Sun, 18 Jan 2009 11:58:58 -0600
From: Jay Cliburn <jcliburn@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>,
       jie.yang@atheros.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [atl2] warn_slowpath in dev_watchdog
Message-ID: <20090118115858.1b636b2d@osprey.hogchain.net>
In-Reply-To: <879024.62535.qm@web110609.mail.gq1.yahoo.com>
References: <gkt97e$ti0$1@ger.gmane.org>
	<20090117194045.649f55a0@osprey.hogchain.net>
	<767752.95325.qm@web110601.mail.gq1.yahoo.com>
	<20090118095231.2c73c448@osprey.hogchain.net>
	<879024.62535.qm@web110609.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2009 09:40:15 -0800 (PST)
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:


> [  125.684886] atl2: eth0 NIC Link is Down
> [  127.459033] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
> [  148.170925] atl2: eth0 NIC Link is Down
> [  149.736346] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
> [  199.704086] ------------[ cut here ]------------
> [  199.704095] WARNING: at net/sched/sch_generic.c:226 dev_watchdog+0x22b/0x240()
> [  199.704101] NETDEV WATCHDOG: eth0 (atl2): transmit timed out

Thanks Sitsofe.  This is what I was looking for.

I'll wait for you to try the patch I sent earlier.  I'd like to see if
the watchdog timeout occurs with the patch applied.

Thanks again,
Jay
