Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYHXCjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYHXCjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 22:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYHXCjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 22:39:41 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:23855 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751425AbYHXCjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 22:39:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=xqZN/OJX7f8JUkBxzIduEV+jKnhggY8+oqswzDBFvuLaNTkwvSKncK2Mg9JNFL7Gzwb2KRAMDWNIXxoa6UqMeIAgUAqVoVbA+WGVwHfBrW+E5+ZKaZlbpqahFBQlCDarlxeXHX8H8CvGCk7Wt1abeaT/bazUxRbADx+H2jmK4xQ=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Sat, 23 Aug 2008 19:39:39 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <558013.68193.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > (BTW, just what kernel version were you using for those patches?  The
> > v2.6.27-rcX series place the patch's changes over 100 lines earlier
> > than the line numbers indicated in your patches....)
> 
> we are working on tip/master

My mistake... sorry.  Previously, Ingo had me doing things with tip/master,
but usually you had me working with v2.6.27-rc3.  I should have tried
tip/master as soon as I saw the discrepancy.


I have some questions about what happens next:

- This fix will naturally make it into v2.6.27, maybe even as soon
as v2.6.27-rc5, correct?

- Is there any chance I can get it into the stable 2.6.26.X updates?
(Who should I ask, or are only developers allowed to lobby for this
sort of thing?)

- Are you worried about the potential problems of a quirk-based approach?
What if many more people experience a similar regression once 2.6.26 or
later appears in their distribution?  I'm sure you don't want to have to
write a different quirk for each individual's hardware, and this problem
did not arise with the approach used for resource management in 2.6.25.


Thanks again Yinghai (and Ingo),
Dave W.
