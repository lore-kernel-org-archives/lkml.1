Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXCORke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXCORke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXCORke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:40:34 -0400
Received: from h155.mvista.com ([63.81.120.155]:26596 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932223AbXCORkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:40:33 -0400
Message-ID: <45F98502.50509@ru.mvista.com>
Date: Thu, 15 Mar 2007 20:40:18 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Woody Suwalski <woodys@xandros.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] sl82c105: add ->speedproc support
References: <45F86058.6090509@ru.mvista.com> <45F956B4.1060309@xandros.com> <20070315173633.GA26160@flint.arm.linux.org.uk>
In-Reply-To: <20070315173633.GA26160@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Russell King wrote:

>>> I wonder is there are some W83C554 users anywhere -- that chipset 
>>>also supports UltraDMA...

>>Sergei,

>>ARM Netwinder machines are running hard disk IDE on SL82c105.
>>Could you send me the actual source file to try (or a patch)?

> That's actually a W83C553 which does not support UDMA in any shape or
> form according to the documents.

> I guess it's an enhancement found on W83C554, and in that case any
> attempt to add UDMA support to the SL82C105 driver should be done
> such that these older chipsets continue to work.

    I had no plans of adding it so far since there seemed to be no designs 
using that chip but decided to ask if somebody is interested just in case...

MBR, Sergei
