Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYDPWM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYDPWM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYDPWMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:12:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:9622 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYDPWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sPmxbRm2WOfbcb6dow8GRzjmf2I9fX5wFtWHNmY0dRDwohZJqCobyV9/ZbBNDJcB8DmhKjjbjw6OQJmOq8SS1IVN4LbuozEPaWuG3TMj/IMyP6iaLRRn3DQI0NimPaWz2EhybHq4W0xtS1sCpVztHQkShlZS1ogQDcdlht9/Nvk=
Message-ID: <480679D3.7030705@gmail.com>
Date: Thu, 17 Apr 2008 07:12:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
References: <200804021524.27222.elendil@planet.nl> <20080415144748.GO7385@csclub.uwaterloo.ca> <48053AD1.8010007@gmail.com> <200804162008.27655.elendil@planet.nl>
In-Reply-To: <200804162008.27655.elendil@planet.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Wednesday 16 April 2008, Tejun Heo wrote:
>> Yeah, theoretically, you're right.  The problem is that what breaks when
>> things go wrong.  If you don't probe generic ports by default, harddisks
>> won't be detected on some legacy systems but you can always prompt the
>> user about loading the generic driver.  If you probe generic ports by
>> default, when things go wrong, you break modern machines in an
>> unrecoverable (w/o reset) way.  I'd rather choose bothering the user on
>> legacy machines.
> 
> The problem here is determining whether a machine is "legacy" or not.
> So far in this discussion I've seen no suggestions how to do that (except 
> maybe for my test whether /sys/bus/isa is present), which would mean asking 
> _all_ users, and that's a damned ugly option.

Asking when no harddisk is detected w/ the option to choose it 
explicitly should do for most cases.  No?

-- 
tejun
