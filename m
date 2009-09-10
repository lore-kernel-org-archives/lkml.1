Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZIJGZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZIJGZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZIJGZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:25:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55194 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZIJGZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:25:31 -0400
Message-ID: <4AA89B02.1050909@zytor.com>
Date: Wed, 09 Sep 2009 23:21:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com>	<20090908203323.486c129c@caramujo.chehab.org>	<4AA6F63F.7090009@zytor.com>	<20090908235441.04549a29@caramujo.chehab.org>	<4AA73309.8030302@zytor.com> <20090910010512.60a1f523@caramujo.chehab.org>
In-Reply-To: <20090910010512.60a1f523@caramujo.chehab.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 09:05 PM, Mauro Carvalho Chehab wrote:
>  {
> +	static char ptychar[] = "pqrstuvwxyzabcde";
> +

Oh yes, this should be "static const char ...".

> +	 *   The second nibble encoded with ptychar;
> +	 *   The first nibble, printed in hexadecimal;
> +	 *   The other nibbles, printed in hexadecimal.

The last two are in the wrong order (and you reversed the order of the
code from my example, which made that harder to see.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

