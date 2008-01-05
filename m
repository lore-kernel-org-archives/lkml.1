Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYAEBjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYAEBjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 20:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYAEBi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 20:38:59 -0500
Received: from japan.chezphil.org ([77.240.5.4]:2318 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbYAEBi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 20:38:58 -0500
To: <linux-kernel@vger.kernel.org>
Date: Sat, 05 Jan 2008 01:38:53 +0000
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <1199497133856@dmwebmail.japan.chezphil.org>
In-Reply-To: <20080105010639.GA8417@slug>
References: <20080105010639.GA8417@slug>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> On Fri, Jan 04, 2008 at 09:01:38PM +0000, Phil Endecott wrote:
>> struct sockaddr_in client_addr;
>> socklen_t client_size=sizeof(client_addr);
>> int connfd = accept(fd,(struct sockaddr*)(&client_addr),&client_size);
>> if (connfd==-1) {
>>   // [1]
>>   .....report error and terminate......
> Replacing the (connfd == -1) check with (connfd < 0),
> could you try printf'ing connfd and errno here?
> Just to confirm strace's output.

Yes, I've already added something like that.  Now we just need to wait 
for it to crash again, which will happen faster if people in a 
different timezone go and play with 
http://demos.anyterm.org/bastet/anyterm.html while I sleep....

Phil.

(Your are welcome to Cc: me in any replies)




