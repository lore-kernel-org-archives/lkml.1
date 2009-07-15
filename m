Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZGOKEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZGOKEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZGOKEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:04:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55920 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752181AbZGOKEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:04:53 -0400
Date: Wed, 15 Jul 2009 11:05:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090715110533.62daf05e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090714162837.GC3145@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
	<20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
	<20090711235530.GA3231@localdomain.by>
	<20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
	<20090714162837.GC3145@localdomain.by>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 19:28:37 +0300
Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> Hello Alan,
> I'm having another problem which I guess may be caused by pty/tty changes.
> The problem is that ppp connection constantly hangups under load (downloading) 
> (it works perfectly with 30 kernel).

Have you also got the unthrottle change reverted - without that revert it
certainly will hang as you describe.
