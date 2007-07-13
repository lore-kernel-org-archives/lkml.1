Return-Path: <linux-kernel-owner+w=401wt.eu-S935965AbXGMNwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935965AbXGMNwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbXGMNwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:52:21 -0400
Received: from main.gmane.org ([80.91.229.2]:48086 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761092AbXGMNwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:52:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <wa1ter@myrealbox.com>
Subject: Re: On current git head webservers stopped working
Date: Fri, 13 Jul 2007 06:52:04 -0700
Organization: none
Message-ID: <f78025$m3u$1@sea.gmane.org>
References: <469745A8.6010005@googlemail.com> <20070713093459.GB5328@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-194-123.dsl.irvnca.pacbell.net
User-Agent: Thunderbird 3.0a1pre (X11/2007070907)
In-Reply-To: <20070713093459.GB5328@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Jul 13 2007, Gabriel C wrote:
>> Hello ,
>>
>> While doing some tests with 2.6.22-git2 ( at the time head
>> 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4 ) all my webservers stopped
>> working.
>> I can't get any file using wget or whatever else , everything hangs
>> after 1% forever.
>>
>> I bisected this and here the result:
>>
>> 534f2aaa6ab07cd71164180bc958a7dcde41db11 is first bad commit
>> commit 534f2aaa6ab07cd71164180bc958a7dcde41db11
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Fri Jun 1 14:52:37 2007 +0200
>>
>>     sys_sendfile: switch to using ->splice_read, if available
...

> Does this work?
<patch snipped>

Hi Jens,
I was hoping this patch would fix a different problem caused by the
same merge of 'splice-2.6.23' three days ago, but it didn't.

When I run nfsd on the latest git kernel, it serves up what seems to
be the wrong inodes for every fetched file.  I can navigate the served
directory structure with no problems, but the contents of any file I
fetch are completely unrelated to the real contents.

Does this suggest a possible cause or fix?

Thanks.


