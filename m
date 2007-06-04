Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXFDE6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXFDE6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 00:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXFDE6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 00:58:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:9980 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbXFDE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 00:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=cBn0/iMdIGIYXAsrQZkiMV+zYwSiAzjFRMRHnSa+Rucq4gDwR0kBULZfBV4wyMgD5oS+3g3bAHoy5P9mFuQfo7TOtK5JVMKn2snyJU+BYgzB+cD2f0KFZNIInQyafGlOI+S50Z+z8g67VLRg5vvzotYaHOy6uiVh1ob2XHt3Yhk=
Date: Mon, 4 Jun 2007 12:58:57 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070604045857.GE2161@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Al Viro <viro@ftp.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4662DFCF.3010606@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 11:35:43AM -0400, Jeff Garzik wrote:
>Randy Dunlap wrote:
>>On Sun, 3 Jun 2007 15:29:39 +0100 Al Viro wrote:
>>
>>>On Sun, Jun 03, 2007 at 10:24:50PM +0800, WANG Cong wrote:
>>>  
>>>>+Do care when you use Lindent to indent your code, since it may use 
>>>>spaces
>>>>+instead of tabs before a goto label and it may also align the label in a
>>>>+wrong position. A goto label should be aligned in the column that is 8
>>>>+characters ahead of the statement just below this label. Please fix it 
>>>>manually
>>>>+if you find Lindent is wrong.
>>>Lindent is wrong, but the style you are advocating is, at the very
>>>least, not universal.  Equally (if not more) common is putting label
>>>in column 1, period.  Regardless of indentation level of the statement
>>>following it.
>>
>>ack Al's style.
>
>Seconded.  All my code contains the goto label in the first column.
>
>IMO any other goto label indentation is silly, because it obscures the 
>goto label within the code block.
>
>	Jeff

Thanks for all comments!

I just wonder, if a goto label is nested in a while/for/if/switch block, aligning it in
the first column maybe a bit ugly. (I know mostly it is not in any while/for/if/switch block.)

Regards!


WANG Cong

