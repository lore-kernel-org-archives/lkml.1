Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZCZTm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZCZTm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZCZTmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:42:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48963 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756402AbZCZTmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:42:19 -0400
Date: Thu, 26 Mar 2009 19:42:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, greg@kroah.com
Subject: Re: USB: serial: add symbol serial driver
Message-ID: <20090326194228.52087a47@lxorguk.ukuu.org.uk>
In-Reply-To: <200903261929.n2QJTS5L009700@hera.kernel.org>
References: <200903261929.n2QJTS5L009700@hera.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 19:29:28 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

Thank you for not running this past the tty layer maintainer.


> +	/*
> +	 * Force low_latency on so that our tty_push actually forces the data
> +	 * through, otherwise it is scheduled, and with high data rates (like
> +	 * with OHCI) data can get lost.
> +	 */
> +	if (tty)
> +		tty->low_latency = 1;

The above is bogus cargo cult programming copied from old drivers and
should be removed.



Otherwise looks fine
