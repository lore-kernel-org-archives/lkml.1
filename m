Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZA0UQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZA0UQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZA0UQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:16:49 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37886 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZA0UQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:16:48 -0500
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Doug Thompson <norsk5@yahoo.com>, <linux-mm@kvack.org>,
       <bluesmoke-devel@lists.sourceforge.net>
Subject: Re: marching through all physical memory in software
References: <497DD8E5.1040305@nortel.com>
	<20090126075957.69b64a2e@infradead.org> <497F5289.404@nortel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jan 2009 12:16:52 -0800
In-Reply-To: <497F5289.404@nortel.com> (Chris Friesen's message of "Tue\, 27 Jan 2009 12\:29\:29 -0600")
Message-ID: <m1vds0bj2j.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chris Friesen" <cfriesen@nortel.com> writes:

> Arjan van de Ven wrote:
>> On Mon, 26 Jan 2009 09:38:13 -0600
>> "Chris Friesen" <cfriesen@nortel.com> wrote:
>>
>>> Someone is asking me about the feasability of "scrubbing" system
>>> memory by accessing each page and handling the ECC faults.
>>>
>>
>> Hi,
>>
>> I would suggest that you look at the "edac" subsystem, which tries to
>> do exactly this....


> edac appears to currently be able to scrub the specific page where the fault
> occurred.  This is a useful building block, but doesn't provide the ability to
> march through all of physical memory.

Well that is the tricky part.  The rest is simply finding which physical
addresses are valid.  Either by querying the memory controller or looking
at the range the BIOS gave us.

That part should not be too hard.  I think it simply has not been implemented
yet as most ECC chipsets implement this in hardware today.

Eric
