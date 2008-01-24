Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYAXOsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYAXOsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYAXOs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:48:29 -0500
Received: from xdsl-9553.wroclaw.dialog.net.pl ([84.40.234.81]:49439 "HELO
	mail.alfa-net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751737AbYAXOs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:48:28 -0500
Message-ID: <4798A537.9000104@gmail.com>
Date: Thu, 24 Jan 2008 15:48:23 +0100
From: Marcin Gil <marcin.gil@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
References: <200801232323.36187.marcin.gil@gmail.com> <20080123234639.025cc859@lxorguk.ukuu.org.uk> <479839B4.3060202@gmail.com> <20080124142717.GA16173@csclub.uwaterloo.ca> <4798A114.6010803@gmail.com> <20080124144359.GD16171@csclub.uwaterloo.ca>
In-Reply-To: <20080124144359.GD16171@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, Jan 24, 2008 at 03:30:44PM +0100, Marcin Gil wrote:
>> This is not a problem. I've posted (in original mail) that DVD is found 
>> fine (and linked as /dev/cdrom). But I have a Maxtor HDD on the same 
>> ide-tape and it is not detected at all.
> 
> Are you using an 80 pin IDE cable and are both drives set to cable
> select (usually preferable) or is one master and one slave?
> 
Yes, this is 80-wire cable; both are connected on the same cable. HDD is 
master and DVD is slave. I'll later try disconnecting DVD and see what 
happens. I didn't set cable-select due to how these drives are connected

+-----+-----+
mobo  hdd   dvd

I think that cable select would take dvd as master and hdd as slave.
This was not preferable when hdd was my primary drive. I can try 
cable-select now since I boot off new SATA drive.

Thank you,
-Marcin Gil

