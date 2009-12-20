Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZLTJLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZLTJLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZLTJLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:11:47 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:34840
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbZLTJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:11:46 -0500
Date: Sun, 20 Dec 2009 10:11:38 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, mjt@tls.msk.ru,
       mmarek@suse.cz
Subject: Re: 2.6.33-rc1 Reboot right after bootloader
Message-ID: <20091220091138.GA1793@trillian.comsick.at>
References: <20091219233457.GA4288@trillian.comsick.at>
 <20091220084656.GA485@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220084656.GA485@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009.12.20 09:46:56 , Sam Ravnborg wrote:
> Hi Michael & Oliver.
> 
> Just to check what is going wrong here could you try to execute the following two commands:
> printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
> /usr/bin/printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
> echo -ne \\xa8\\x51\\x37\\x00 > x ; hexdump x
> 
> Please try as above and also with full path to printf (/usr/bin/printf)
> 
> On my system it looks like this:
> 
> $ printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
> 0000000 51a8 0037
> 0000004
Hi Sam,

With bash as shell I get the same results, dash is different though.

$ printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 785c 3861 785c 3135 785c 3733 785c 3030
0000010

$ /usr/bin/printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 51a8 0037                              
0000004

$ echo -ne \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 6e2d 2065 785c 3861 785c 3135 785c 3733
0000010 785c 3030 000a                         
0000015

Kind regards,
Michael
