Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586Ab0AMPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0AMPi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150Ab0AMPi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:38:26 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55061 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab0AMPiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:38:25 -0500
Date: Wed, 13 Jan 2010 16:38:22 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: Changelog quality (was Re: [PATCH] uwb: make USB device id
 constant)
In-Reply-To: <4B4DDFDB.2000408@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk>
References: <4B4C297A.5090405@freemail.hu> <4B4C9ED9.60905@csr.com>
 <4B4CAA15.4030200@freemail.hu> <4B4DDFDB.2000408@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When you write a changelog, keep your audience in mind:
> 
>   - Developers, distributors, advanced users want to learn what a new
>     release brings.  (OK, this audience stops reading after the initial
>     headline of a "make XYZ table constant" commit.  Which just means
>     that all the rest of the changelog is fluff that can be omitted.)
> 
>   - Developers, maintainers etc. want to understand years later why the
>     code is how it is.  (For them, a commit like that is sufficiently
>     described by the headline as well.)

Not surprisingly, I don't agree about this one.  I recall a series of 
patches that said something like "used a script to change down/up to 
mutexes".  The script wasn't included, not all down/ups were changed to 
mutexes, and in short there was no understandable trace of why the change 
was made where it was.  Perhaps that is a pathological example, but it is 
not necessarily obvious in advance what needs precise documentation and 
what does not.

julia
