Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZCCPeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZCCPeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZCCPdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:33:54 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58298 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZCCPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:33:54 -0500
Message-ID: <49AD4DA0.6040400@s5r6.in-berlin.de>
Date: Tue, 03 Mar 2009 16:32:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add to_delayed_work macro
References: <20090303083440.57df68c3@hyperion.delvare>	<20090303002952.80f1afc8.akpm@linux-foundation.org> <20090303102236.1ad909ad@hyperion.delvare>
In-Reply-To: <20090303102236.1ad909ad@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Tue, 3 Mar 2009 00:29:52 -0800, Andrew Morton wrote:
>> On Tue, 3 Mar 2009 08:34:40 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>> 
>> > +#define to_delayed_work(_work)	container_of(_work, struct delayed_work, work)
>> 
>> As this is specifically designed to operate on a `struct work*', as
>> opposed to "any struct which has a field called `work'", we can get
>> additional type-safety by putting a C interface around it.
> 
> This is what I wanted to do in the first place, but then I noticed that
> _all_ such wrappers around container_of are implemented as macros
> rather than inline functions.

/Almost/ all.

http://lxr.linux.no/linux+v2.6.28/drivers/firewire/fw-device.h#L73

> So I decided to follow the crowd. Any idea why it is so?

Merely old habits.
-- 
Stefan Richter
-=====-==--= --== ---==
http://arcgraph.de/sr/
