Return-Path: <linux-kernel-owner+w=401wt.eu-S1031105AbXDSDem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031105AbXDSDem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 23:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031102AbXDSDem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 23:34:42 -0400
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:53777 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031096AbXDSDel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 23:34:41 -0400
X-Greylist: delayed 3923 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 23:34:41 EDT
Message-ID: <4626D3D5.2060408@soft.fujitsu.com>
Date: Thu, 19 Apr 2007 11:28:37 +0900
From: izumi <izumi2005@soft.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH][BUG] Fix possible NULL pointer access in 8250 serial
 driver
References: <46242DD2.7030207@soft.fujitsu.com> <20070416225206.cf7d8cd2.akpm@linux-foundation.org> <1176884513.3945.54.camel@kane-linux> <20070418191812.GA21211@flint.arm.linux.org.uk>
In-Reply-To: <20070418191812.GA21211@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:

> NAK.  This means that you change the list of ports available on the
> machine to be limited to only those which are currently open.  Utterly
> useless for debugging, where you normally want people to dump the
> contents of /proc/tty/driver/*.
> 
> The original patch was better.
> 

   Is the original patch sufficient?  or is there anything we should 
correct?

Taku Izumi <izumi2005@soft.fujitsu.com>



