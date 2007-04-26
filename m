Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXDZHt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXDZHt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXDZHtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:49:25 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:64680 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbXDZHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:49:24 -0400
Message-ID: <4630595D.3050901@alcatel-lucent.com>
Date: Thu, 26 Apr 2007 15:48:45 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Questions on printk and console_drivers
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au>
In-Reply-To: <46305327.2000206@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2007 07:48:45.0950 (UTC) FILETIME=[5190A1E0:01C787D7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I got a questions on printk and console_drivers. I have 2 serial ports 
and want to see output from all of them. So I registered 2 console 
driver using register_console. I can see the output from serial port 1 
after it was registered, but can't see any output from it after serial 
port 2 has been registered.

I don't why.

Thanks,
Gavin
