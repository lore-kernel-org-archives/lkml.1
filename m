Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbYCJLXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbYCJLXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYCJLX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:23:28 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:46282 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYCJLXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:23:20 -0400
Message-ID: <47D51A0C.4030102@mandic.com.br>
Date: Mon, 10 Mar 2008 08:22:52 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel Linux 2.6.23.16 hangs when run updatedb
References: <187848749@web.de>
In-Reply-To: <187848749@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> Renato S. Yamane wrote:
>> when cron start updatedb daemon, my machine hangs. None key work, so I 
>> need reset (press power button to restart).
>>
>> The only way to get log is runing updatedb from terminal (CTRL + ALT + 
>> F1) and take a picture from screen:
>>
>> Up screen:
>> <http://img137.imageshack.us/img137/7128/01pg1.jpg>
>>
>> Down screen:
>> <http://img100.imageshack.us/img100/1456/02kx1.jpg>
>>
>> Call trace detail:
>> <http://img100.imageshack.us/img100/8233/calltracedetailsj7.jpg>
>
> looks like reiserfs issue.
> maybe corrupt filesystem and improper handling of the reiserfs-driver?
> 
> could you try some "find /" ?

"find /" don't hangs my machine.
The problem is only with updatedb.

How can I fix this? Is safe run reiserfsck?

Regards,
Renato S. Yamane
