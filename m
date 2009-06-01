Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZFAQnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZFAQnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZFAQmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:42:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36023 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbZFAQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:42:53 -0400
Date: Mon, 1 Jun 2009 17:41:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090601161234.GA10486@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think. As for other unhandled sig_fatal() signals, I am nor sure.
> I can make a patch, but first I need to know what this patch should do.
> Again, please look at:

If you are on the command line then SIGINT/SIGQUIT would be the obvious
ones for this ?

