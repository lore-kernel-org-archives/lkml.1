Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbZDGLKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbZDGLKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZDGLJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:09:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41855 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbZDGLJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:09:58 -0400
Date: Tue, 7 Apr 2009 12:11:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elina <epasheva@sierrawireless.com>
Cc: <gregkh@suse.de>, <rfiler@sierrawireless.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 003/003] USB:  serial: sierra driver bug fixes in
 open/close and callbacks
Message-ID: <20090407121104.718d109a@lxorguk.ukuu.org.uk>
In-Reply-To: <1239062762.10120.38.camel@Linuxdev3>
References: <1239062762.10120.38.camel@Linuxdev3>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 17:06:02 -0700
Elina <epasheva@sierrawireless.com> wrote:

> Subject: [PATCH 003/003] USB:  serial: sierra driver bug fixes in 
> open/close and callbacks
> From: Elina Pasheva <epasheva@sierrawireless.com>

NAK this patch

It puts back stuff that was removed in other bug fixing (eg
tty->low_latency setting). Some of the other stuff looks odd too - but
its hard to read with the mixing of formatting/debug changes and other
code changes.

The tty = NULL assignment for one makes no sense.
