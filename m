Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYGUWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYGUWe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYGUWeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:34:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbYGUWeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:34:03 -0400
Date: Mon, 21 Jul 2008 18:27:02 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix serial_txx9 compile.
Message-ID: <20080721222702.GA19033@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080721211659.GA29106@redhat.com> <20080721230028.1c7020c9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721230028.1c7020c9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 11:00:28PM +0100, Alan Cox wrote:
 > On Mon, 21 Jul 2008 17:16:59 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > drivers/serial/serial_txx9.c: In function 'receive_chars':
 > > drivers/serial/serial_txx9.c:275: error: 'struct uart_info' has no member named 'tty'
 > 
 > Already fixed ages ago. Its in a patch that didn't get to Linus yet - see
 > the linux-next tree for the stuff pending.

Odd. This breakage happened with the merge in -git8
Why didn't the associated fixes go along with that merge ?
If it was fixed ages ago, that implies we knowingly merged broken code,
which seems suboptimal.  If nothing else, we're breaking bisectability
by merging in two batches.

	Dave

-- 
http://www.codemonkey.org.uk
