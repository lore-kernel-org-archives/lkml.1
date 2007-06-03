Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbXFCPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbXFCPgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXFCPgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 11:36:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38225 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXFCPgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 11:36:04 -0400
Message-ID: <4662DFCF.3010606@garzik.org>
Date: Sun, 03 Jun 2007 11:35:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
       Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain>	<20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net>
In-Reply-To: <20070603074552.430c3d02.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 3 Jun 2007 15:29:39 +0100 Al Viro wrote:
> 
>> On Sun, Jun 03, 2007 at 10:24:50PM +0800, WANG Cong wrote:
>>   
>>> +Do care when you use Lindent to indent your code, since it may use spaces
>>> +instead of tabs before a goto label and it may also align the label in a
>>> +wrong position. A goto label should be aligned in the column that is 8
>>> +characters ahead of the statement just below this label. Please fix it manually
>>> +if you find Lindent is wrong.
>> Lindent is wrong, but the style you are advocating is, at the very
>> least, not universal.  Equally (if not more) common is putting label
>> in column 1, period.  Regardless of indentation level of the statement
>> following it.
> 
> ack Al's style.

Seconded.  All my code contains the goto label in the first column.

IMO any other goto label indentation is silly, because it obscures the 
goto label within the code block.

	Jeff



