Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbXD0Rd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbXD0Rd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbXD0Rd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:33:29 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:36832 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756090AbXD0Rd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:33:27 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 13:33:27 EDT
Message-ID: <46322E08.3040303@moving-picture.com>
Date: Fri, 27 Apr 2007 18:08:24 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: X display shift with disabled console blanking
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a problem whereby the X display 'shifts' to left when anything 
writes to /dev/console - where console screen blanking has been disabled 
i.e. doing something like:

boot to run level 3

If not root, then make sure /dev/console is writeable

login and type:

setterm -blank 0

start X

type into an xterm:

echo "some random text" > /dev/console
(may have to repeat the echo above a few times)

... and the whole X display jumps (and wraps) to the left

I'm using a RHEL4 based distro with a vanilla 2.6.21 x86_64 kernel 
(although I've seen the problem with various x86_64 and i686 2.6.X kernels).

I've seen this problem on a number of different nVidia cards - using 
the vesa driver (same problem occurs with nVidia's binary driver). I 
haven't tried using other makes of graphics cards.


OK, this may be a strange combination of disabling the text console 
blanking and running X, but something isn't right somewhere ...

Any ideas?

Thanks

James Pearson
