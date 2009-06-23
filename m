Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbZFWNAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbZFWNAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZFWNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:00:37 -0400
Received: from dan.rpsys.net ([93.97.175.187]:55613 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbZFWNAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:00:36 -0400
Subject: Re: Bug in tdo24m
From: Richard Purdie <rpurdie@rpsys.net>
To: Aviv Laufer <aviv.laufer@gmail.com>
Cc: eric.miao@marvell.com, linux-kernel@vger.kernel.org
In-Reply-To: <87972c700906230516n538ad959nbd4b1ea21943ffc2@mail.gmail.com>
References: <87972c700906230516n538ad959nbd4b1ea21943ffc2@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 13:58:53 +0100
Message-Id: <1245761933.5987.20.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-06-23 at 15:16 +0300, Aviv Laufer wrote:
> I have found a bug in tdo24m.c .
> There is a call to kmalloc with the second param is sizeeof (flag)
> instead of flag.
> This cause  a crash.

Thats quite a nasty bug and its surprising its not been found before
now! Can you resubmit the patch with description and most importantly a
Signed-off-by line please (see Documentation/SubmittingPatches)?

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

