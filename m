Return-Path: <linux-kernel-owner+w=401wt.eu-S1763828AbYCDIkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763828AbYCDIkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbYCDIkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:40:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34517 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763548AbYCDIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:40:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CD0AD7.9080700@s5r6.in-berlin.de>
Date: Tue, 04 Mar 2008 09:39:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kristian H?gsberg <krh@bitplanet.net>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: reread config ROM when device reset the bus
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>	<tkrat.da30e6f15a74e036@s5r6.in-berlin.de>	<59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>	<47CC2C95.1050205@s5r6.in-berlin.de>	<59ad55d30803030928t47ab84ebs1f37434d6558b72e@mail.gmail.com>	<47CC3C48.1020306@s5r6.in-berlin.de>	<47CC44DB.1060203@s5r6.in-berlin.de> <20080304055448.GB15566@suse.de>
In-Reply-To: <20080304055448.GB15566@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Ah, semaphore fun in the device.  If at all
> possible, use your own, not the driver core as the locking there is a
> bit "odd" as you have seen.  I think Alan Stern has some patches pending
> to mess with it all to try to make it sane during the suspend/resume
> path.

OK, I will redo it so that I don't have to assume anything about 
driver-core internal locking.  Thanks,
-- 
Stefan Richter
-=====-==--- --== --=--
http://arcgraph.de/sr/
