Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0CJLRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:17:04 -0500
Received: from cordova.acsalaska.net ([209.112.173.243]:20946 "EHLO
	cordova.acsalaska.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab0CJLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:16:59 -0500
X-Greylist: delayed 2569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 06:16:59 EST
Date: Wed, 10 Mar 2010 01:34:09 -0900
From: rogerx@sdf.org
To: linux-kernel@vger.kernel.org
Subject: 'struct uart_port' has no member named 'info
Message-ID: <20100310103409.GA7451@localhost2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (cordova.acsalaska.net [209.112.168.121]); Wed, 10 Mar 2010 01:34:10 -0900 (AKST)
X-ACS-Spam-Status: no
X-ACS-Scanned-By: MD 2.64; SA 3.2.5; spamdefang 1.122
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upgraded from kernel-2.6.32 to kernel-2.6.33, and now get the following
error when compiling ltmodem.

I checked for changes within drivers/serial/serial_core.c, but couldn't
find the specific change.  (I did verify ltmodem compiles fine without
error under 2.6.32.)


/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c: In
function 'receive_chars':
/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:181:
error: 'struct uart_port' has no member named 'info'
/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c: In
function 'transmit_chars':
/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:243:
error: 'struct uart_port' has no member named 'info'
/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c: In
function 'check_modem_status':
/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:284:
error: 'struct uart_port' has no member named 'info'
/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.c:294:
error: 'struct uart_port' has no member named 'info'
make[2]: ***
[/var/tmp/portage/net-dialup/ltmodem-20090420/work/ltmodem/v8250.o]
Error 1


-- 
Roger
http://rogerx.freeshell.org/
