Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbYEYEAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYEYEAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYEYEAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:00:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYEYEAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:00:08 -0400
Date: Sun, 25 May 2008 00:03:30 -0400
From: Rik van Riel <riel@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Use structs instead of hardcoded offsets in x86
 boot decompressor.
Message-ID: <20080525000330.3eedd788@riellaptop.surriel.com>
In-Reply-To: <4837B2DD.908@zytor.com>
References: <1211579968-15227-1-git-send-email-krh@redhat.com>
	<20080523210744.52fe7fde@bree.surriel.com>
	<4837B2DD.908@zytor.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 23:17:01 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Uhm... except it doesn't live at address zero, at all.
> 
> It's called "zeropage" because we used to recycle it into 
> empty_zero_page, a long long time ago.
> 
> The bootparms structure is pointed to by %esi being passed from the 
> setup code to the decompressor to the kernel.

Then why does dereferencing the uninitialized
pointer work, both in the code before and after
the patch?

What am I misssing?
