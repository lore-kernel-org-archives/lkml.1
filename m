Return-Path: <linux-kernel-owner+w=401wt.eu-S967813AbXFHDXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967813AbXFHDXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966457AbXFHDXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:23:05 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:18582 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965252AbXFHDXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:23:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMwAEZnaEZKhRO4UGdsb2JhbACBTYVmiCwBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Paul Albrecht <albrecht@rdi1.com>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Date: Thu, 7 Jun 2007 23:23:04 -0400
User-Agent: KMail/1.9.3
Cc: lkml <linux-kernel@vger.kernel.org>
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
In-Reply-To: <1181236651.15435.1.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706072323.05576.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 07 June 2007 13:17, Paul Albrecht wrote:
> Hi,
> 
> I'm trying use the 2.6.20 kernel and have run into a problem using the
> ps/2 keyboard with console. When I type input in response to console
> output the characters aren't echo'ed and the console program doesn't
> receive the character input. It seems like the problem is specific to
> the ps/2 interface because a usb keyboard works fine.

I think this bug is fixed in newer kernels. Please try the latest 2.6.21.y
and if it still does not work please send me full dmesg after booting with
"i8042.debug log_buf_len=131072". Thanks!

-- 
Dmitry
