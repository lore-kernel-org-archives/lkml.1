Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYGCW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYGCW1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYGCW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:27:15 -0400
Received: from smtp.ono.com ([62.42.230.12]:22163 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754862AbYGCW1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:27:14 -0400
Date: Fri, 4 Jul 2008 00:27:09 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Possible out-of-bounds array accesses in rc8-git3
Message-ID: <20080704002709.6119f0d5@werewolf.home>
X-Mailer: Claws Mail 3.5.0cvs1 (GTK+ 2.13.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

Building latest kernel with gcc-4.3.1, I get this warnings, look related
to some memcpy passing bad lengths.
Could someone that knew the code take a look ?

drivers/acpi/tables/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
include/asm/string_32.h:65: warning: array subscript is above array bounds

...

drivers/usb/core/hcd.c: In function ‘usb_hcd_poll_rh_status’:
include/asm/string_32.h:65: warning: array subscript is above array bounds

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam13 (gcc 4.3.1 20080515 (GCC) #1 SMP
