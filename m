Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbYA1BuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbYA1BuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYA1Bt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:49:59 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:35979 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752705AbYA1Bt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:49:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xDWrkY4oXibiM753B855zv4DyXBxZkUropVlNon7Jt+qc6PSD5p7kW/9JuoXJ3cM2UwNI/THiWVyNRXii5WGMibqE/lRCHUzB+RnMjw/yK4jBkson6EqqJ0dBqDGnAmWVxXp6Sz1JbexOpN5NQr7M0Qkm6HI4MBTY9BYzwmZZDY=  ;
X-YMail-OSG: o__QdVkVM1nYgUi4qrxRKBljiq1kojQpiQfUkSxxcIEYWeB8oT91nxPXdLm9kanw3OCW85dTn7VQKLBhjIJSAHJiHmRLL5z4MvGDmu11po01WdUDcbOmhE8vYMmuxw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Mon, 28 Jan 2008 12:49:42 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1200949086.6648.19.camel@Anastacia> <200801270046.26648.nickpiggin@yahoo.com.au> <loom.20080126T142451-347@post.gmane.org>
In-Reply-To: <loom.20080126T142451-347@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281249.43151.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 01:27, Pascal Terjan wrote:
> Nick Piggin <nickpiggin <at> yahoo.com.au> writes:
> > On Sunday 27 January 2008 00:29, Frederik Himpe wrote:
> > > I just succeeded to reproduce the problem with this patch. Does this
> > > smell like an XFS problem?
>
> I got the same issue using ext3
>
> > Possible. Though I think it is more likely to be a bug in the
> > new deadlock avoidance code in the generic buffered write path.
> > Dang... I wonder why this hasn't come up earlier. It looks like
> > pan's use of writev might be tickling it.
> >
> > How quickly can you reproduce this?
>
> When I was using pan daily one month ago, I got it twice over a week
>
> > Can you use strace to see what the hanging syscall looks like?
>
> I tried last week during 5 hours without luck, I can try again

Dang, I didn't see any reports of this earlier :(

Anyway, I sent a patch to fix it in the original thread (can you
reply-to-all please? just it a bit easier to keep threads together)

Thanks,
Nick
