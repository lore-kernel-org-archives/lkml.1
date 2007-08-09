Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbXHIACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbXHIACw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765542AbXHIAC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:02:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764251AbXHIACZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:02:25 -0400
Date: Wed, 8 Aug 2007 17:02:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: early boot lockup with 2.6.23-rc1
Message-Id: <20070808170211.4401c019.akpm@linux-foundation.org>
In-Reply-To: <20070808223120.GA2286@nalle>
References: <20070808223120.GA2286@nalle>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 01:31:20 +0300
Mikko Rapeli <mikko.rapeli@iki.fi> wrote:

> Since 2.6.23-rc1 I can't boot an old k6 (with a funky IDE drive worth testing
> with libata). The boot hangs without a sound or letter prints on the
> screen right after grub, while 2.6.22.1 works fine.

Try adding the `earlyprintk=vga' parameter to the kernel command line?
