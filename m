Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbXLIXqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbXLIXqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 18:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXLIXpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 18:45:54 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:54558 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751616AbXLIXpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 18:45:52 -0500
Date: Mon, 10 Dec 2007 00:42:11 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-ID: <20071210004211.145487b7@morte>
In-Reply-To: <248113.29149.qm@web52903.mail.re2.yahoo.com>
References: <20071209230652.7156fe17@morte>
	<248113.29149.qm@web52903.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.12.9.152112
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, BODY_SIZE_400_499 0, ECARD_KNOWN_DOMAINS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 22:13:09 +0000 (GMT)
Chris Rankin <rankincj@yahoo.com> wrote:

> --- Stefano Brivio <stefano.brivio@polimi.it> wrote:
> > Not a fix, but if you load the module with ignore_cis = 1, it should work.
> 
> Well, if the I/O memory mapping is broken then wouldn't that just move the
> problem down to the next attempt to access it?

Dunno but this helped in a similar crash I had some months ago, IIRC.


-- 
Ciao
Stefano
