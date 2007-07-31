Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbXGaEIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbXGaEIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXGaEIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:08:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:38534 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbXGaEIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hKcbUw+rNoUF6DCD8WOHHtGM96QQLpfCo+kK6//DMwucWqqOjTAy4HCcFmdCmQAAaWwVIOQOzaCrLgshKfLXddBHWWdP0BJYX6/VQG8PLSxutxRCPFc3D5+75oEQY8ep5jexqovUaExOWMm3aVahqEgmdidGEjpyc39hzmV/Fpk=
Message-ID: <46AEB59B.7030909@gmail.com>
Date: Tue, 31 Jul 2007 08:07:55 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [2/3] 2.6.23-rc1: known regressions v3
References: <46AE0F5D.3000500@googlemail.com> <46AE12F5.4030706@googlemail.com> <200707302208.20891.ismail@pardus.org.tr> <Pine.SOC.4.64.0707302301290.14147@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0707302301290.14147@math.ut.ee>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
>>> Subject         : New ACPI error/warning with Linus' latest GIT
>>> References      : http://lkml.org/lkml/2007/7/26/395
>>> Last known good : ?
>>> Submitter       : Ismail Dönmez <ismail@pardus.org.tr>
>>> Caused-By       : ?
>>> Handled-By      : ?
>>> Status          : unknown
>> This started to happen after the second ACPI merge which was for 2.6.23-rc2.
> 
> It appeared after new Embedded Controller code was merged into ACPI. It 
> might as well be just a debug message or a remainder to add support for 
> new queries (whatever these are), but I do not know. The message itself 
> seems harmless.
> 
This _is_ a debug message. EC asks us to perform query which was never defined in DSDT.
Previously I thought it would be rare error report, but now it seems that every machine
has at least one unregistered query... It is not a functional regression, as we just 
ignored errors from query execution before.

Len already has a patch to remove this printk.

Regards,
	Alex.
