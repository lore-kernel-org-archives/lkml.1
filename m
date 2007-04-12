Return-Path: <linux-kernel-owner+w=401wt.eu-S1030841AbXDLWjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030841AbXDLWjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030844AbXDLWjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:39:54 -0400
Received: from gw.goop.org ([64.81.55.164]:51185 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030841AbXDLWjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:39:54 -0400
Message-ID: <461EB515.4080106@goop.org>
Date: Thu, 12 Apr 2007 15:39:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org> <200704122321.23318.ak@suse.de>
In-Reply-To: <200704122321.23318.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hmm, does Xen perhaps not use interrupt stacks? Normally 2.7k should be still
> green as long as there are not too many functions above/below it.
>   

That's a good point, I'll need to check that.  Still, nearly 3k of stack!

    J
