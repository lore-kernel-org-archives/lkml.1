Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbZFJPw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbZFJPw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbZFJPwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:52:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55871 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757391AbZFJPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:52:18 -0400
Date: Wed, 10 Jun 2009 16:53:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] Char: tty, remove sleep_on
Message-ID: <20090610165333.3a8a166f@lxorguk.ukuu.org.uk>
In-Reply-To: <1244635684-8318-1-git-send-email-jirislaby@gmail.com>
References: <1244635684-8318-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 14:08:03 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Use wait_event instead of sleep_on in tty_block_til_ready.
> 
> Wait for ASYNC_CLOSING flag being 0.

Both applied
