Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbZD2Bmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbZD2Bmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZD2Bma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:42:30 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44182 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZD2Bm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <20090428215844.GA1396@sysman-doug.us.dell.com>
References: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> 
	<ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com> 
	<20090426085401.3788fc9c@hyperion.delvare> <20090427132041.GA18391@sc1430.michaels-house.net> 
	<20090427172710.5a0c7f48@hyperion.delvare> <437908170904271023k3eefd4c1ma0cacdb78ad7acd7@mail.gmail.com> 
	<20090428101020.0e4c2b0c@hyperion.delvare> <20090428173929.GA5006@sysman-doug.us.dell.com> 
	<ac3eb2510904281046i6e9899acg89f7606da783f72c@mail.gmail.com> 
	<20090428215844.GA1396@sysman-doug.us.dell.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 03:42:08 +0200
Message-ID: <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com>
Subject: Re: Class device namespaces
To: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Michael Brown <mebrown@michaels-house.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 23:58, Doug Warzecha <Douglas_Warzecha@dell.com> wrote:
> On Tue, Apr 28, 2009 at 07:46:57PM +0200, Kay Sievers wrote:
>> On Tue, Apr 28, 2009 at 19:39, Doug Warzecha <Douglas_Warzecha@dell.com> wrote:
>>
>> > /sys/class/firmware/dell_rbu/loading
>> > /sys/class/firmware/dell_rbu/data
>>
>> These pathes only ever exist for a fraction of a second, during a
>> kernel initiated firmware request. This request is usually only
>> handled by the udev firmware loader script, and not interesting for
>> anything else. Are you replacing the udev firmware script here? Are
>> you sure you do something else here?
>
> A Dell library writes data to those paths when a Dell BIOS Update Package is run and requests the BIOS image to be loaded into memory.

How do you do this? These paths exist for a short time only. How do
you get udev out of your way handling the firmware request for you?
How do you plug into the event processing with a custom tool?

Thanks,
Kay
