Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbXAZVFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbXAZVFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXAZVFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:05:05 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:52106 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbXAZVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:05:04 -0500
Message-ID: <45BA6CF9.1030505@gmail.com>
Date: Fri, 26 Jan 2007 22:04:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Khai Doan <khai@genius.com>, linux-kernel@vger.kernel.org
Subject: Re: How to create a fixed length character/block device/file ?
References: <45BA6018.5040406@genius.com> <45BA6999.4000807@cfl.rr.com>
In-Reply-To: <45BA6999.4000807@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi napsal(a):
> Khai Doan wrote:
>> Sorry if this is the wrong list.  I've search google, but have not 
>> found solution to my problem.
>>
>> I have a long running application which split out lots of debugging 
>> information.  I can't redirect the output to a regular file because 
>> that file would grow and eat up all the diskspace.  I can't redirect 
>> to /dev/null.  What I want is the last 1MB of the output before my 
>> application terminated.  So I need to create a special file / device 
>> on the system.  Please tell me if  there is an existing device that I 
>> can use, or point me in the right direction so that I can role my own 
>> device.
> 
> myapp | tail -c1048576 > logfile

AFAIK this will output the file after the app termination. He wants to know the 
log before that.

Just write your own reader which will output last meg in some intervals...

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
