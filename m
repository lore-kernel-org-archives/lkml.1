Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZCKIi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZCKIi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZCKIiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:38:50 -0400
Received: from web4112.mail.ogk.yahoo.co.jp ([124.83.200.74]:42840 "HELO
	web4112.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752005AbZCKIit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:38:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=tNnFZ7NNeOMEct7aZbUMZDMgSn5rdhmxOBXu43LGki5rx1Y8WXrVnIJPYV3caG52M9yJkyx6IjOvRAXMglX+X4aXmj96VVjIvw4nYWsJTxFIU6sp5Q/QADZwqBND0b3I  ;
Message-ID: <20090311083846.5137.qmail@web4112.mail.ogk.yahoo.co.jp>
Date: Wed, 11 Mar 2009 17:38:46 +0900 (JST)
From: Norman Diamond <n0diamond@yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Subject: Re: Off-by-one in both LIBATA and IDE drivers
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       n0diamond@yahoo.co.jp
In-Reply-To: <20090311082725.37cb1883@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Norman Diamond <n0diamond@yahoo.co.jp> wrote:
> 
>> It looks like both LIBATA and the old IDE drivers
>> have an off-by-one error in deciding whether to use
>> READ SECTOR(S) instead of READ SECTOR(S) EXT.
> 
> This was fixed some time ago, you need a newer
> kernel.

Well, either that or I need an older kernel.  It was also
fixed in 2.6.20, for which I think there was a ready-made
Slax distribution.

On another topic, trying 2.6.20 in whatever Slax
distribution it was, an Intel ICH7M had DMA enabled on
both /dev/hda and /dev/hdc.  I understand that the change
which was made shortly after that is considered to be by
design not a bug.  In 2.6.20 I didn't even have to type a
"combined_mode" parameter, it just worked.  I understand
that the addition and subsequent deletion of the
"combined_mode" parameter are considered to be by design
not bugs.  But it is not at all pleasant that my /dev/hda
runs at 1.3 megabytes per second in 2.6.24.3 and later,
when it used to run at 45 megabytes per second in 2.6.20. 
Yeah I know libata is supposed to solve all this stuff. 
Removed some bugs and added others.

I can't go newer than 2.6.24.3 until I find a version
where TASKFILEs start working again.  There might not be
one.  Yeah I know libata is supposed to solve all this
stuff.  I wonder how much time I'll need and how many
varieties of hardware I'll have to buy to see if it's
really fixed.


--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
