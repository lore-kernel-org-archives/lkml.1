Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZJJW4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZJJW4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 18:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZJJWz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 18:55:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37153 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754771AbZJJWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 18:55:59 -0400
Date: Sat, 10 Oct 2009 23:56:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bernhard@bwalle.de>
Subject: Re: [PATCH 1/5] Only define/declare kmsg_redirect when
 CONFIG_VT_CONSOLE is set
Message-ID: <20091010235640.723aca4f@lxorguk.ukuu.org.uk>
In-Reply-To: <1255207870-24496-2-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
	<1255207870-24496-2-git-send-email-bernhard@bwalle.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009 22:51:06 +0200
Bernhard Walle <bernhard@bwalle.de> wrote:

> Since the variable is only used when CONFIG_VT_CONSOLE is set, we can save some
> bytes of memory when CONFIG_VT_CONSOLE is not set.

Its four bytes.. its not worth the ifdef mess

