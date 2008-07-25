Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYGYSxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYGYSxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYGYSwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:52:40 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:1346 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYGYSwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:52:39 -0400
Message-ID: <fa686aa40807251152t22848f69l924b0f83f1871165@mail.gmail.com>
Date: Fri, 25 Jul 2008 14:52:38 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [PATCH v3 1/4] of: adapt of_find_i2c_driver() to be usable by SPI also
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org
In-Reply-To: <9e4733910807251002w7da115e5r53600f1cf4e3891@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
	 <20080725073311.8485.16226.stgit@trillian.secretlab.ca>
	 <9e4733910807250840n48c6ae79l27af4f320b5b1df1@mail.gmail.com>
	 <fa686aa40807250921v73bec21cya6b4cd494f12f2e8@mail.gmail.com>
	 <9e4733910807251002w7da115e5r53600f1cf4e3891@mail.gmail.com>
X-Google-Sender-Auth: 10a2404fed80f883
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 1:02 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On 7/25/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Fri, Jul 25, 2008 at 11:40 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
>>  > On 7/25/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>>  >>  + * First method is to lookup the compatible value in of_modalias_table.
>>  >>  + * Second is to look for a "linux,<modalias>" entry in the compatible list
>>  >>  + * and used that for modalias.  Third is to strip off the manufacturer
>>  >>  + * prefix from the first compatible entry and use the remainder as modalias
>>  >
>>  > I also think this is a problem. Embedding the name of Linux device
>>  > drivers into device firmware makes it almost impossible to rename the
>>  > device driver.  Again, what is a case where generic part numbers can't
>>  > be listed in the alias section of the linux device driver?
>>  >
>>  > Even eeprom was just fixed to take generic part numbers (at24).
>>
>> Again, I agree, but this change is very much a stop gap measure to get
>>  things working in a sane way without having to create bad device tree
>>  bindings (device tree bindings are hard to change, code is not).  I've
>>  been considering posting a patch to remove this clause from the
>>  functions, but that needs to be reviewed separately from this change.
>
> Isn't putting "compatible="linux,modalias"" into your device tree a
> really bad idea?

Yes, it is, but I still need to preserve existing behavior in this
patch.  That change needs to be reviewed separately.  I'll submit
another patch to deal with this.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
