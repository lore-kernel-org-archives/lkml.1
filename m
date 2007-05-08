Return-Path: <linux-kernel-owner+w=401wt.eu-S968768AbXEHWul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968768AbXEHWul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968619AbXEHWuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:50:12 -0400
Received: from smtpout09-04.prod.mesa1.secureserver.net ([64.202.165.17]:58274
	"HELO smtpout09.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S968610AbXEHWuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:50:10 -0400
Message-ID: <4640FEA0.3020407@seclark.us>
Date: Tue, 08 May 2007 18:50:08 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: start flamewar about use of braces
References: <200705081903.l48J3AOw010373@hera.kernel.org> <20070508124301.17975a4f.randy.dunlap@oracle.com> <4640E971.9050400@garzik.org> <20070508222540.GG8753@csclub.uwaterloo.ca>
In-Reply-To: <20070508222540.GG8753@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:

>On Tue, May 08, 2007 at 05:19:45PM -0400, Jeff Garzik wrote:
>  
>
>>>>+Do not unnecessarily use braces where a single statement will do.
>>>>+
>>>>+if (condition)
>>>>+	action();
>>>>+
>>>>+This does not apply if one branch of a conditional statement is a single
>>>>+statement. Use braces in both branches.
>>>>+
>>>>+if (condition) {
>>>>+	do_this();
>>>>+	do_that();
>>>>+} else {
>>>>+	otherwise();
>>>>+}
>>>>        
>>>>
>>If anyone tries to add braces to my code's 'else' statements where they 
>>are not required, that patch will get NAK'd in a heartbeat.
>>    
>>
>
>Oh isn't coding style fun.  I personally hate code that doesn't ALWAYS
>have the braces everywhere since it makes adding a print statement
>or other debuging to the condition such a pain since you then have to
>add braces to the condition to avoid breaking the code just to insert
>a print statement.  It is one of the few things I disagree with in the
>linux kernel coding style.
>
>--
>Len Sorensen
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
I agree - it is merely defensive programming to always have the braces, 
it prevents someone
from sticking in a diag and forgetting to add braces so things go haywire.

My $.02
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



