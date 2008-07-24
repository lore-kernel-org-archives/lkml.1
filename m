Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbYGXCbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbYGXCbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 22:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYGXCbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 22:31:31 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:53294 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYGXCba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 22:31:30 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 22:31:30 EDT
Message-ID: <4887E700.6060602@isomerica.net>
Date: Wed, 23 Jul 2008 22:20:48 -0400
From: =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Peter Zijlstra <peterz@infradead.org>, Rafal Wijata <devnull@wijata.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Odd swapping issue
References: <488761F0.4040906@wijata.com> <1216835428.7257.194.camel@twins> <4887A000.30605@davidnewall.com>
In-Reply-To: <4887A000.30605@davidnewall.com>
X-Enigmail-Version: 0.95.6
OpenPGP: url=http://isomerica.net/~dpn/gpgkey
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Peter Zijlstra wrote:
>> 16g ram on a 32bit kernel is stretching it... may I suggest running a
>> 64bit kernel?
>>   
> 
> Is it?  Do we expect that behaviour with so much RAM?

The memory must be mapped into the 4GB (32-bit) virtual address space to
be used.  Having this much memory on a system with 32 bit pointers leads
to a lot of VM overhead and strange behavior.

Cheers,
Dan

-- 
                    /--------------- - -  -  -   -   -
                    |  Dan Noé
                    |  http://isomerica.net/~dpn/
