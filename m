Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYJNJna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYJNJna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYJNJnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:43:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39079 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754161AbYJNJnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:43:22 -0400
Date: Tue, 14 Oct 2008 10:40:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/5] hvc_console: Add tty driver flag
 TTY_DRIVER_RESET_TERMIOS
Message-ID: <20081014104025.517ae734@lxorguk.ukuu.org.uk>
In-Reply-To: <20081014091413.003841094@linux.vnet.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
	<20081014091413.003841094@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 11:12:49 +0200
Hendrik Brueckner <brueckner@linux.vnet.ibm.com> wrote:

> From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> 
> After a tty hangup() or close() operation, processes might not reset the
> termio settings to a sane state.

That is the job of the getty task normally. pty is special as the reissue
of the same pty is done as a new device (with new state).

Setting this on the hvc would parallel the PC vt console behaviour but
differ from most other ports.

Anyway its a policy question for PPC64 so if thats how you want it to work

Acked-by: Alan Cox <alan@redhat.com>

