Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZJBKiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZJBKiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbZJBKiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:38:16 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:43547 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532AbZJBKiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:38:15 -0400
Message-ID: <4AC5D810.3080307@msgid.tls.msk.ru>
Date: Fri, 02 Oct 2009 14:38:08 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14270] Cannot boot on a PIII Celeron
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>	 <COE24pZSBH.A.7sH.xMTxKB@chimera> <aa79d98a0910020130p4d3c5b5fh9597ea435db7f872@mail.gmail.com> <4AC5C42E.9070909@msgid.tls.msk.ru>
In-Reply-To: <4AC5C42E.9070909@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Cyrill Gorcunov wrote:
>> On 10/1/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.30 and 2.6.31.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>>> be listed and let me know (either way).
>>
>> Michael has been asked to bisect it (if possible). I cant reproduce it
>> in kvm unfortunately.
> 
> Yes, and that's what I'll be trying to do shortly.
> I had other issues to sort out and wasn't able to
> get to it in few last days.
> 
> Also I've a few other suspects.  For example, in this .31
> config I changed from bzip to lzma compression - and that's
> where (or near) kernel is rebooting.

And that was the problem.  After switching from LZMA
to BZIP2 kernel boots again.

Dunno if it can be treated as a regression, but it's
definitely a bug.

/mjt

>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14270
>>> Subject        : Cannot boot on a PIII Celeron
>>> Submitter    : Michael Tokarev <mjt@tls.msk.ru>
>>> Date        : 2009-09-28 15:26 (4 days old)
>>> References    : http://marc.info/?l=linux-kernel&m=125415160524110&w=4
>>>
>>>
>>>
> 

