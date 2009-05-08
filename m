Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbZEHLRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbZEHLRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZEHLQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:16:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39684 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932262AbZEHLQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:16:05 -0400
Date: Fri, 8 May 2009 12:13:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Ferenc Wagner <wferi@niif.hu>
Subject: Re: [PATCH 1/2] Char: rocket, fix ASYNC flags
Message-ID: <20090508121306.643f41c3@lxorguk.ukuu.org.uk>
In-Reply-To: <1241771564-31133-1-git-send-email-jirislaby@gmail.com>
References: <8763gcsa5e.fsf@tac.ki.iif.hu>
	<1241771564-31133-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 May 2009 10:32:43 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> ASYNC_* flags are not bits, but rather constants, use ilog2 to obtain
> bit positions and stay atomic.

Definitely agree with the bug but it would I think be cleaner to add
ASYNCF_.. (or ASYNCB_.. or similar) that is the bit numbers rather than
use ilog2. That also means we can later delete ASYNC_xxx from the kernel
side to stop people using them unsafely in drivers 

