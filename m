Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXFDOR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXFDOR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbXFDORu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:17:50 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:34360 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXFDORt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:17:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18020.7945.364135.889997@stoffel.org>
Date: Mon, 4 Jun 2007 10:17:45 -0400
From: "John Stoffel" <john@stoffel.org>
To: "Aaron Wiebe" <epiphani@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
In-Reply-To: <e7ca40f70706040704w450dd609g46b6e7a3689ff11@mail.gmail.com>
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	<20070604144918.42354235@the-village.bc.nu>
	<e7ca40f70706040704w450dd609g46b6e7a3689ff11@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Aaron" == Aaron Wiebe <epiphani@gmail.com> writes:

Aaron> On 6/4/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> 
>> > Now, I'm a userspace guy so I can be pretty dense, but shouldn't a
>> > call with a nonblocking flag return EAGAIN if its going to take
>> > anywhere near 415ms?
>> 
>> Violation of causality. We don't know it will block for 415ms until 415ms
>> have elapsed.

Aaron> Understood - but what I'm getting at is more the fact that
Aaron> there really doesn't appear to be any real implementation of
Aaron> nonblocking open().  On the socket side of the fence, I would
Aaron> consider a regular file open() to be equivalent to a connect()
Aaron> call - the difference obviously being that we already have a
Aaron> handle for the socket.

Aaron> The end result, however, is roughly the same.  We have a file
Aaron> descriptor with the endpoint established.  In the socket world,
Aaron> we assume that a nonblocking request will always return
Aaron> immediately and the application is expected to come back around
Aaron> and see if the request has completed.  Regular files have no
Aaron> equivalent.

So how many files are in the directory where you're seeing the delays?
And what's the average size of the files in there?  

John
