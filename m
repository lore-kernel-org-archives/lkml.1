Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbYF0MYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbYF0MYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYF0MYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:24:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35395 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYF0MYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:24:19 -0400
Message-ID: <4864DBE3.3040801@jp.fujitsu.com>
Date: Fri, 27 Jun 2008 21:24:03 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       auke-jan.h.kok@intel.com, jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH 1/3] e1000: make ioport free
References: <485B1B8E.1060108@jp.fujitsu.com> <485B1C31.4020507@jp.fujitsu.com> <486483DF.5060404@garzik.org>
In-Reply-To: <486483DF.5060404@garzik.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jeff

Jeff Garzik wrote:
> Taku Izumi wrote:
>> This patch makes e1000 driver ioport-free.
>> This corrects behavior in probe function so as not to request ioport
>> resources as long as they are not really needed. This is based on the
>> ioport-free patch of e1000 driver from Auke Kok and Tomohiro Kusumi.
>>
>>
>> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
>> ---
>>  drivers/net/e1000/e1000.h      |    4 +
>>  drivers/net/e1000/e1000_main.c |   88 +++++++++++++++++++++++++++++++++++------
>>  2 files changed, 80 insertions(+), 12 deletions(-)
>
> ACK but failed to apply
>

I'll re-create one.

Taku Izumi <izumi.taku@jp.fujitsu.com>


