Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZDVPcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZDVPcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZDVPcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:32:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47905 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753313AbZDVPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:32:30 -0400
Date: Wed, 22 Apr 2009 16:33:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Igor Zhbanov <izh1979@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Idea: Feature information / extensions dispatcher syscall.
Message-ID: <20090422163336.2054409b@lxorguk.ukuu.org.uk>
In-Reply-To: <f44001920904220822k672def82t7e9ba646bdde5fe8@mail.gmail.com>
References: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com>
	<871vrkpyae.fsf@basil.nowhere.org>
	<f44001920904220732h2d6d18cfwef53af31bb218b87@mail.gmail.com>
	<f44001920904220746k356550abk6783b8cae003685d@mail.gmail.com>
	<20090422161257.2743ea33@lxorguk.ukuu.org.uk>
	<f44001920904220822k672def82t7e9ba646bdde5fe8@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, you need a file handle. To open device each time you need to make ioctl
> is expensive and keeping device opened may prevent unmounting /proc
> that could be a problem in some installations if that application is used
> at a boot time.

- Nobody in the real world unmounts /proc.
- You don't need to use /proc anyway
- You don't need to open the device each ioctl
- Even if you did open is extremely quick

