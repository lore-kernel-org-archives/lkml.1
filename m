Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbXLKOR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbXLKOR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXLKORw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:17:52 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44238 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbXLKORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:17:51 -0500
Message-ID: <475E9B9B.2050709@keyaccess.nl>
Date: Tue, 11 Dec 2007 15:15:55 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl> <20071211143224.15900995@tux.DEF.witbe.net>
In-Reply-To: <20071211143224.15900995@tux.DEF.witbe.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 14:32, Paul Rolland wrote:

>> On 11-12-07 13:08, David Newall wrote:
>>
>>> Rene Herman wrote:
> 
>> (*) some local testing shows it to be almost exactly that for both out and 
>> in on my own PC -- a little over. If anyone cares, see attached little test 
>> program. The "little over" I don't worry about. 0 us delay is also fine for 
>> me and if any code was _that_ fragile it would have broken long ago.
> 
> Some results :

Okay, these vary to wildly for you and might I suppose be a serialising 
artifact or some such. Give me a bit and I'll try to improve it...

Rene
