Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbYHNJRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbYHNJRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYHNJRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:17:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbYHNJRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:17:40 -0400
Date: Thu, 14 Aug 2008 02:17:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Trevor Woollacott [ MTN - Innovation Centre ]" <Woolla_T@mtn.co.za>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: POSIX_FADV_DONTNEED
Message-Id: <20080814021703.355b2a76.akpm@linux-foundation.org>
In-Reply-To: <70D00C33FCD1FD4A860DEAC228277C0C048425D1@MTNMAIL1.mtn.co.za>
References: <70D00C33FCD1FD4A860DEAC228277C0C048425D1@MTNMAIL1.mtn.co.za>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 17:05:39 +0200 "Trevor Woollacott [ MTN - Innovation Centre ]" <Woolla_T@mtn.co.za> wrote:

> 
> Hi all
> 
> Does anyone know if posix_fadvise() with POSIX_FADV_DONTNEED is
> blocking/unblocking?

It tries to be nonblocking and will mostly succeed in that.  It might
occasionally block on a metadata read or journal congestion or
something, so it isn't guaranteed.

