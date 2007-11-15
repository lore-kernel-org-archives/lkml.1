Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbXKOUJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbXKOUJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXKOUJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:09:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932137AbXKOUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:09:16 -0500
Date: Thu, 15 Nov 2007 12:09:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lucy McCoy <lucy@keyspan.com>
Cc: bbpetkov@yahoo.de, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
Message-Id: <20071115120909.133e8e52.akpm@linux-foundation.org>
In-Reply-To: <473C86A2.1060505@keyspan.com>
References: <20071103100301.GA5615@gollum.tnic>
	<473C86A2.1060505@keyspan.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 09:49:22 -0800 Lucy McCoy <lucy@keyspan.com> wrote:

> Greg & Boris,
> 
> I've been out of town and just saw this.
> 
> This patch will work with the 19HS but WILL BREAK all other Keyspan
> adapters.  It will take me a few days to get to looking at a correct fix but
> that keyspan_send_setup(port, 1) (and the '1' is the important part) 
> must happen once
> when the port is first opened.  The cflag can just be set to whatever 
> the normal default
> is for your serial environment.  What are the defaults?
> 

drat, this patch just went into mainline.

If you're sure that it'll break things, I'll revert it while you cook up
something better, OK?

