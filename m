Return-Path: <linux-kernel-owner+w=401wt.eu-S936234AbXGSBJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936234AbXGSBJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760778AbXGSBJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:09:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760487AbXGSBJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:09:43 -0400
Date: Wed, 18 Jul 2007 18:08:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Gustavo de Nardin <gustavodn@mandriva.com.br>
Subject: Re: [PATCH] Include serial_reg.h with userspace headers
Message-Id: <20070718180829.8f736843.akpm@linux-foundation.org>
In-Reply-To: <200707150002.39321.herton@mandriva.com.br>
References: <200707150002.39321.herton@mandriva.com.br>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 00:02:39 -0300
Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> As reported by Gustavo de Nardin <gustavodn@mandriva.com.br>, while trying to 
> compile xosview (http://xosview.sourceforge.net/) with upstream kernel 
> headers being used you get the following errors:
> serialmeter.cc:48:30: error: linux/serial_reg.h: No such file or directory
> serialmeter.cc: In member function 'virtual void 
> SerialMeter::checkResources()':
> serialmeter.cc:71: error: 'UART_LSR' was not declared in this scope
> serialmeter.cc:71: error: 'UART_MSR' was not declared in this scope
> ...
> 
> I don't know if it's right to provide serial_reg.h with userspace headers, may 
> be serial_reg.h isn't included for some reason. But if it's ok, the following 
> patch adds serial_reg.h to be installed with user space kernel headers:
> 

Well that file is just a pile of "#define name number"s so I guess it's
OK to export it to save someone some typing, and to avoid breaking existing
stuff more than we need to.

