Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905Ab0A0TBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0A0TBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079Ab0A0TBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:01:22 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10209 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0A0TBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:01:22 -0500
Message-ID: <4B608D78.4040606@caviumnetworks.com>
Date: Wed, 27 Jan 2010 11:01:12 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joel Schopp <jschopp@austin.ibm.com>
CC: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
References: <1264597747.3607.29.camel@wall-e> <4B6080C5.7020306@austin.ibm.com>
In-Reply-To: <4B6080C5.7020306@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2010 19:01:11.0851 (UTC) FILETIME=[1792CFB0:01CA9F83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Schopp wrote:
> 
>> The time of 80 characters punch card and terminals are over, so i would
>> be a good thing to set the line length limit to 120. Every display today
>> should be able handle this.   
> Nack.
> 
> While the origins of 80 character lines dates back to punchcards there 
> is a reason it has survived the test of time.

Has it though?  If that were the undisputed truth, we wouldn't be having 
this discussion.  Also it is likely that there would be very few devices 
capable of displaying more than 80 columns.

> Lines that go longer are hard to comprehend.

Not universally.

> Either they are long themselves, in which case 
> breaking them up into smaller chunks on multiple lines helps 
> readability,

... Or sometimes it results in gibberish.

> or they are starting from deep indentation, in which case 
> the function should be refactored or broken up so the logic is more 
> digestable. --

The problem with the checkpatch.pl tool is that its use results in 
people trying to eliminate warnings.  In the case of the 80 column 
warning, this can result in going against the goal stated in CodingStyle 
Chapter 2:  "Coding style is all about readability and maintainability..."

Perhaps checkpatch.pl needs a third level of diagnostic.  Perhaps:

NOTICE: line over 80 characters

Indicating that the line in question should be given extra attention, 
but weaker than a WARNING.

In any event, it is always fun to discuss these questions of style.


David Daney

