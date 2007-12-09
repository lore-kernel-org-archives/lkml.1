Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXLIWKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXLIWKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXLIWKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:10:33 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:54886 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188AbXLIWKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:10:33 -0500
Date: Sun, 9 Dec 2007 23:06:52 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-ID: <20071209230652.7156fe17@morte>
In-Reply-To: <587622.50680.qm@web52902.mail.re2.yahoo.com>
References: <1193657365.19938.17.camel@localhost.localdomain>
	<587622.50680.qm@web52902.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, BODY_SIZE_600_699 0, ECARD_KNOWN_DOMAINS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 19:41:58 +0000 (GMT)
Chris Rankin <rankincj@yahoo.com> wrote:

> Hi,
> 
> I've recently been having trouble loading the hostap_plx 802.11b wireless
> networking driver, and this evening I managed to narrow the problem down
> to these lines of code by copying code from hostap_plx into a "test
> driver" until the test driver also locked the PC up:
> 
>         /* read CIS; it is in even offsets in the beginning of attr_mem */
>         for (i = 0; i < CIS_MAX_LEN; i++)
>                 cis[i] = readb(attr_mem + 2 * i);

Not a fix, but if you load the module with ignore_cis = 1, it should work.


-- 
Ciao
Stefano
