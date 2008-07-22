Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYGVApa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYGVApa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYGVApV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:45:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbYGVApU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:45:20 -0400
Date: Mon, 21 Jul 2008 20:38:14 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-ID: <20080722003814.GA14809@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-next@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	ppc-dev <linuxppc-dev@ozlabs.org>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 10:25:20AM +1000, Stephen Rothwell wrote:
 > Hi Linus, Alan,
 > 
 > Today's linux-next (actually just Linus' tree) build (powerpc
 > ppc64_defconfig) failed like this:
 > 
 > drivers/serial/serial_txx9.c: In function 'receive_chars':
 > drivers/serial/serial_txx9.c:275: error: 'struct uart_info' has no member named 'tty'
 > drivers/serial/icom.c: In function 'recv_interrupt':
 > drivers/serial/icom.c:733: error: 'struct uart_info' has no member named 'tty'

That's the same pair of patches I sent earlier, which apparently were
"Already in the ttydev tree" which should be in linux-next ?

	Dave
 
-- 
http://www.codemonkey.org.uk
