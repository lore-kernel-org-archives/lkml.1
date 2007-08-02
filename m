Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXHBXhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXHBXhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbXHBXhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:37:09 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:39366 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbXHBXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:37:07 -0400
Message-ID: <46B269FC.6020309@gmail.com>
Date: Fri, 03 Aug 2007 01:34:20 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Randy Dunlap <rdunlap@xenotime.net>, Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B2578A.805@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030024490.6774@poirot.grange> <20070802155434.b085219c.rdunlap@xenotime.net> <Pine.LNX.4.60.0708030056390.6774@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708030056390.6774@poirot.grange>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2007 01:26 AM, Guennadi Liakhovetski wrote:

> On Thu, 2 Aug 2007, Randy Dunlap wrote:
> 
>> C99 spec that Al referred you to (available for around US$18 as a pdf) 
>> says in 6.7.8, para. 14 (where Al said):
>> 
>> "An array of character type may be initialized by a character string
>> literal, optionally enclosed in braces. Successive characters of the
>> character string literal (including the terminating null character if
>> there is room or if the array is of unknown size) initialize the 
>> elements of the array."
> 
> Wow... So, the terminating '\0' in the string constant IS "special" and 
> "optional"... Ok, then, THIS does answer my question, THIS I can 
> understand, and, ghm, accept...
> 
> Thanks to all who tried to explain this to me and sorry it took so
> long...

Ah come on, it would be great fun to now make the argument that that quoted 
bit doesn't actually say wat should happen when there's _no_ room for the 
terminating null character...

Rene.
