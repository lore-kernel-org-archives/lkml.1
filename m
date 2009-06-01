Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZFAVbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZFAVbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZFAVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:31:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45307 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750819AbZFAVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:31:45 -0400
Date: Mon, 1 Jun 2009 22:32:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Pavel Roskin <proski@gnu.org>, Aaditya.Rai@atheros.com,
       Prem.Kumar@atheros.com, Stephen.Chen@atheros.com,
       Rahul.Sridhar@atheros.com, Allen.Tsai@atheros.com
Subject: Re: EXPORT_SYMBOL_GPL recursive for shim and/or wrappers
Message-ID: <20090601223215.7a81c875@lxorguk.ukuu.org.uk>
In-Reply-To: <43e72e890906011241u24b82cc3gc06bf7be4f43075e@mail.gmail.com>
References: <43e72e890906011241u24b82cc3gc06bf7be4f43075e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 12:41:58 -0700
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> The intention behind EXPORT_SYMBOL_GPL seems clear to me -- prevent
> proprietary drivers from using GPL-only symbols. 

It's a guide as to what symbols are most definitely internal interfaces.
Nobody but a lawyer (or more accurately a court of law I guess) can tell
you what is or isn't a derivative work. It can be that without using _GPL
symbols, and I would imagine there may even be cases the reverse might be
true.
