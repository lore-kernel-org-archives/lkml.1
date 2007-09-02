Return-Path: <linux-kernel-owner+w=401wt.eu-S966247AbXIBL42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966247AbXIBL42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965465AbXIBL4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:56:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964957AbXIBL4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:56:12 -0400
Date: Sun, 2 Sep 2007 04:55:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org, mpm@selenic.com,
       mb@bu3sch.de
Subject: Re: possible BUG while doing gpg --gen-key
Message-Id: <20070902045520.47b0eafe.akpm@linux-foundation.org>
In-Reply-To: <46D0272D.4010800@xs4all.nl>
References: <46CF079C.7010304@xs4all.nl>
	<20070825011419.GL30705@stusta.de>
	<46CFCA78.2090500@xs4all.nl>
	<46D0272D.4010800@xs4all.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 25 Aug 2007 14:57:17 +0200 Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> Udo van den Heuvel wrote:
> > Now it works:
> 
> Stranger even:
> 
> With audio-entropyd, rngd active and the netdev-random patch working I
> cannot reproduce the crash. Even after a fresh boot.

It would really help if your oops stack trace wasn't truncated.  Can you
see if you can generate a complete one using a recent kernel?  Enabling
CONFIG_FRAME_POINTER and disabling CONFIG_4K_STACKS might help in this.

Thanks.

