Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYFQOa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYFQOa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbYFQOaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:30:15 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44678 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757643AbYFQOaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:30:14 -0400
Message-ID: <4857CA71.3020004@davidnewall.com>
Date: Wed, 18 Jun 2008 00:00:09 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: palani saravanan <busybeesaravanan0072003@yahoo.co.in>
CC: linux-kernel@vger.kernel.org
Subject: Re: Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking
 goes beyond file size.
References: <535337.98001.qm@web8712.mail.in.yahoo.com>
In-Reply-To: <535337.98001.qm@web8712.mail.in.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

palani saravanan wrote:
>    In linux, I see that it just goes beyond the file size and returns the resulting offset.
>    For example, 'rc = lseek(fd, 4L, SEEK_END);' on a file which has 5 byte contents,
>    it returns rc as 9.
>   

Sounds right.  It's documented that way, too:

       "The lseek() function allows the file offset to be set beyond the
end of  the  file  (but  this
       does  not  change  the  size of the file)."
           -- man 2 lseek
>    I expect that it would return size of the file, i.e.) 5.
>   

Only if you pass (0,SEEK_END).

>    Does the file pointer internally really points to the new location.?
>   

So the documentation promises.
