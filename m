Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXGHAsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXGHAsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXGHArz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:47:55 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:11050 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbXGHAry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FEYtB+hup2msKPuHvQLFgBnFUhi/5yQbIHTe9Jcgwf+XZHJzX79FJWFG+UXYFnNQx/NrVJBwk1Lpwo14t19tHO1wbmjLpXsEcEI9mYvKgxhbIAYGLoJ7WBR2cCqZyXkNBp/Tvj3bw8wBIyv85sIeKk68USUdEQ87MPI1TFUwREM=
Message-ID: <46903483.3020205@gmail.com>
Date: Sat, 07 Jul 2007 18:49:07 -0600
From: Jim Cromie <jim.cromie@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Coding style on function signatures  (was: Convert tasklets to work
 queues )
References: <20070622182051.859570787@goodmis.org> <20070622182315.571740041@goodmis.org> <20070623095359.4667514e.akpm@linux-foundation.org> <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org> <20070623115252.fc36f20c.rdunlap@xenotime.net> <alpine.LFD.0.98.0706231209130.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706231209130.3593@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>
>   
> Yes, code should be less than 80 characters wide. 
>
> But hey, sometimes it's just more readable to have one line that is 
> slightly longer than it should be, than to split something that is awkward 
> to split. 
>
>   
< cc-list heavily trimmed >


could you speak to the specific case of function signatures ?
I saw nothing in CodingStyle specifically about this.
(I skimmed, and grepped for signature)

forex:

static ssize_t
store_fan_div (struct device *dev, struct device_attribute *devattr,
                    const char *buf, size_t count)
{...}


IIRC, many like the entire sig on one line, because its grep friendly.
I personally like the above, but grep-ability is hard to argue against.

The above has 2 violations (of strict-grep-ability rule)
1 - return sig is separate
2 - arg-list is split
