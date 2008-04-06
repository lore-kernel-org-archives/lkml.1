Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYDFNzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYDFNzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 09:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYDFNzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 09:55:11 -0400
Received: from nn7.de ([85.214.94.156]:44481 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYDFNzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 09:55:10 -0400
Subject: Re: suspend issue
From: Soeren Sonnenburg <kernel@nn7.de>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 06 Apr 2008 13:55:04 +0000
Message-Id: <1207490104.4597.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
> Hello; I seem to have discovered something with echo mem > /sys/power/state.
> I recompile the kernel and had forgotten to compile fglrx, when
> performing a suspend without fglrx I was confronted with the dreaded
> blank screen and a reboot. then as a test I compiled fglrx and loaded,
> and to my amazement suspend reacted properly again.

Yeah, but I it does not even work without X - console only!

s2ram -f -p used to work since at least 2.6.20 ... and is now not
anymore in 2.6.25-*

Soeren
