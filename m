Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZDVNZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZDVNZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZDVNZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:25:06 -0400
Received: from langos.euedge.com ([209.190.22.130]:52087 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZDVNZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:25:05 -0400
Message-ID: <49EF1AAC.3080802@maroy.hu>
Date: Wed, 22 Apr 2009 15:25:00 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
References: <49EDC44D.90106@maroy.hu> <200904211952.25616.oliver@neukum.org> <49EF0ED7.3060706@maroy.hu> <200904221514.34892.oliver@neukum.org>
In-Reply-To: <200904221514.34892.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

> That's odd. I can't tell from the log. Can you make a usbmon trace?

sure:

cat /sys/kernel/debug/usbmon/1u

ffff880088545300 2462700154 S Ii:1:006:1 -115:8 8 <
ffff8800884b2600 2462700171 S Co:1:006:0 s 21 22 0003 0000 0000 0
ffff8800884b2600 2462701898 C Co:1:006:0 0 0
ffff880088545240 2462702064 S Bo:1:006:7 -115 6 = 060a0000 0000
ffff880088545900 2462702133 S Bi:1:006:2 -115 128 <
ffff880088545cc0 2462702142 S Bi:1:006:2 -115 128 <
ffff880088545600 2462702146 S Bi:1:006:2 -115 128 <
ffff8800885450c0 2462702150 S Bi:1:006:2 -115 128 <
ffff8800885453c0 2462702154 S Bi:1:006:2 -115 128 <
ffff880088545480 2462702158 S Bi:1:006:2 -115 128 <
ffff880088545180 2462702162 S Bi:1:006:2 -115 128 <
ffff8800885456c0 2462702166 S Bi:1:006:2 -115 128 <
ffff880088545540 2462702170 S Bi:1:006:2 -115 128 <
ffff880088545000 2462702174 S Bi:1:006:2 -115 128 <
ffff8800885459c0 2462702179 S Bi:1:006:2 -115 128 <
ffff880088545840 2462702183 S Bi:1:006:2 -115 128 <
ffff880088545f00 2462702187 S Bi:1:006:2 -115 128 <
ffff880088545c00 2462702191 S Bi:1:006:2 -115 128 <
ffff880088545b40 2462702199 S Bi:1:006:2 -115 128 <
ffff880088545a80 2462702202 S Bi:1:006:2 -115 128 <


this is where it hangs on poll(). then I press CTRL-C for the
application, then I get:

ffff88007c8e2b40 2502550672 S Co:1:006:0 s 21 22 0000 0000 0000 0
ffff88007c8e2b40 2502552140 C Co:1:006:0 0 0
ffff880088545300 2502553133 C Ii:1:006:1 -2:8 0
ffff880088545240 2502554132 C Bo:1:006:7 -2 0
ffff880088545a80 2502555132 C Bi:1:006:2 -2 0
ffff880088545b40 2502556132 C Bi:1:006:2 -2 0
ffff880088545c00 2502557132 C Bi:1:006:2 -2 0
ffff880088545f00 2502558132 C Bi:1:006:2 -2 0
ffff880088545840 2502559132 C Bi:1:006:2 -2 0
ffff8800885459c0 2502560131 C Bi:1:006:2 -2 0
ffff880088545000 2502561130 C Bi:1:006:2 -2 0
ffff880088545540 2502562126 C Bi:1:006:2 -2 0
ffff8800885456c0 2502563132 C Bi:1:006:2 -2 0
ffff880088545180 2502564131 C Bi:1:006:2 -2 0
ffff880088545480 2502565130 C Bi:1:006:2 -2 0
ffff8800885453c0 2502566125 C Bi:1:006:2 -2 0
ffff8800885450c0 2502567134 C Bi:1:006:2 -2 0
ffff880088545600 2502568134 C Bi:1:006:2 -2 0
ffff880088545cc0 2502569134 C Bi:1:006:2 -2 0
ffff880088545900 2502570134 C Bi:1:006:2 -2 0




Akos
