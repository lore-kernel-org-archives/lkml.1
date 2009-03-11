Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZCKD2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZCKD2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 23:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZCKD2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 23:28:10 -0400
Received: from web4114.mail.ogk.yahoo.co.jp ([124.83.200.76]:38508 "HELO
	web4114.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753530AbZCKD2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 23:28:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=YFnUavnstetaaI0tuENhaj35rZ+oC4kO4XLPSg1zT/tycdSY4wFSJ9iS1c86TyrpucnUisbK8a74W+l8U6JHgwlIv2GEwSSnjMhBaKlnJWpDp4+j+8YV9aTzqNOY/DVJ  ;
Message-ID: <20090311032805.3120.qmail@web4114.mail.ogk.yahoo.co.jp>
Date: Wed, 11 Mar 2009 12:28:05 +0900 (JST)
From: Norman Diamond <n0diamond@yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Subject: Re: Off-by-one in both LIBATA and IDE drivers
To: Jim Paris <jim@jtan.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       n0diamond@yahoo.co.jp
In-Reply-To: <20090311030340.GA617@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Paris wrote:
> Norman Diamond wrote:
>>
>> It looks like both LIBATA and the old IDE drivers
>> have an off-by-one error in deciding whether to use
>> READ SECTOR(S) instead of READ SECTOR(S) EXT.
> 
> This was fixed here:
>
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97b697a11b07e2ebfa69c488132596cc5eb24119

Thank you.

I will see if I can port that fix to 2.6.24.3, because
Slax 6.0.3 and kernel 2.6.24.3 avoided some other bugs of
later kernels.


--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
