Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYJPP4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYJPP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYJPPz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:55:57 -0400
Received: from xenotime.net ([66.160.160.81]:41636 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751507AbYJPPz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:55:57 -0400
Date: Thu, 16 Oct 2008 08:55:54 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG Symbol
In-Reply-To: <241b8f7b0810152356o62bd86eclfa4e0027e41ca563@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810160847230.16496@shark.he.net>
References: <241b8f7b0810152356o62bd86eclfa4e0027e41ca563@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Prabhu Chawandi wrote:

> Hi All,
> 
>   I have added a symobol in thr config file, freshely ... eg.
> CONFIG_USB_SERIAL_CONSOLE

What kind of config file?  Is it in a Kconfig* file?
If so, then the CONFIG_ prefix is implicit and you should just
use "USB_SERIAL_CONSOLE" as the symbol name.

> i.e. there was no symbol at all ... but in the source code a check is
> made for that symbol...
> 
>  So I have added that symbol in the config file,,,
> unfortunately I am not getting that  flag value reflected,,,,

Maybe now it's CONFIG_CONFIG_USB_SERIAL_CONSOLE.

> What I thought ,, Is there any other place where to identify this symbol...
> 
> as we export any symbol...

Config symbols are produced as include/linux/autoconf.h at build time,
so you can look at that file to see what was produced/generated.

-- 
~Randy
