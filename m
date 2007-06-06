Return-Path: <linux-kernel-owner+w=401wt.eu-S1765521AbXFFRop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765521AbXFFRop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXFFRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:44:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbXFFRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:44:37 -0400
Date: Wed, 6 Jun 2007 10:43:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: 2.6.22-rc4-mm1 -- ia64 build failure
Message-Id: <20070606104358.fbafc08b.akpm@linux-foundation.org>
In-Reply-To: <4666BB65.8050800@shadowen.org>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<4666BB65.8050800@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 14:49:25 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> Seeing this on an ia64:
> 
> drivers/built-in.o: In function `efi_setup_pcdp_console':
> (.init.text+0x13be2): undefined reference to `early_serial_console_init'
> drivers/built-in.o: In function `efi_setup_pcdp_console':
> (.init.text+0x13de2): undefined reference to `early_serial_console_init'
> make: *** [.tmp_vmlinux1] Error 1

We really exceeded ourselves this time.  .config, please?
