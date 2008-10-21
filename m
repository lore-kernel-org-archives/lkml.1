Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYJUS6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYJUS6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYJUS5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:57:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54702 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYJUS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:57:53 -0400
Message-ID: <48FE2525.90701@oracle.com>
Date: Tue, 21 Oct 2008 11:53:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Piel <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, burman.yan@gmail.com, pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
References: <48FA3368.1040605@tremplin-utc.net> <20081021114121.5144841c.akpm@linux-foundation.org>
In-Reply-To: <20081021114121.5144841c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 18 Oct 2008 21:05:12 +0200
> Eric Piel <eric.piel@tremplin-utc.net> wrote:
> 
>> ...
>>
>> +/**
>> + * lis3lv02d_acpi_read() - ACPI ALRD method: read a register
> 
> All the kerneldoc comments include the () after the function name. 
> That is unconventional and I do not know what effect it will have upon
> kerneldoc processing and output.

Yes, it's unconventional.
It works.  It (the "()") will be dropped when processed.


>> + * @handle: the handle of the device
>> + * @reg:    the register to read
>> + * @ret:    result of the operation
>> + *
>> + * Returns AE_OK on success.
>> + */
>> +static acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret)
>> +{

