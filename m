Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbXEaSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbXEaSYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbXEaSYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:24:00 -0400
Received: from pool-151-205-99-173.ny325.east.verizon.net ([151.205.99.173]:40103
	"HELO gatworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757060AbXEaSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:23:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 14:23:59 EDT
Message-ID: <465F112C.6090409@gatworks.com>
Date: Thu, 31 May 2007 14:17:16 -0400
From: Uncle George <netbeans@gatworks.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SELECT() returns 1 But FIONREAD says (Input/output error)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i am using the GARMIN_GPS/usb driver to read a gps receiver.
In testing the ability of my software to recover from various errors, I 
try this: unplug the gps/USB cable from the usb hub.

Interestingly enough the thread spins.
the SELECT() waits for something to happen, and I get one channel that 
something interesting happened.
Then i try to find out how many chars are in the read buff via FIONREAD. 
That call errors out with an i/o error.

Needless to day, the code resets the SELECT parameters, and SELECT is 
called again. It again says that something interesting has happened on 
that ( i/o errored ) channel. And we now repeat the  FIONREAD.

In this case what, will reset the "something interesting has happened" 
report from the SELECT call? Will it ever be reset in this case?

