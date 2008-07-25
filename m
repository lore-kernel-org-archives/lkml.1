Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYGYIo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYGYIo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYGYIou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:44:50 -0400
Received: from li26-190.members.linode.com ([67.18.89.190]:54453 "EHLO
	notebook.homenet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752687AbYGYIot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:44:49 -0400
Date: Fri, 25 Jul 2008 10:44:47 +0200
From: Tomas Styblo <tripie@cpan.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
	device 152d:2338
Message-ID: <20080725084447.GA15483@notebook.homenet.local>
References: <Pine.LNX.4.44L0.0807222238060.12003-100000@netrider.rowland.org> <4887BCB9.2000103@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887BCB9.2000103@shaw.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert Hancock <hancockr@shaw.ca> [Thu, 24 Jul 2008]:
>>> Anyway, I'll send the patch to this person so he can try it. I guess it 
>>> won't fix his problem. This patch is much simpler and doesn't need any 
>>> delays - I really think this is a different situation.
>>
>> It isn't.  And your patch is an ad-hoc correction that doesn't address
>> the true underlying reasons for the errors.
>
> Tomas, you should try the patch listed in that bug report (well, except 
> maybe the part that's actually adding the JMicron unusual devices entry) 
> and see if that fixes the problem.

I'll try that patch next week - but I have no confidence in the
reliability of fixing the problem by inserting random delays. All
I have wanted to achieve is to detect the errors and thus prevent
the silent data corruption. 

I don't really mind those sporadic forced resets since they cause
no data corruption, at least in my setup. My simple patch
accomplishes the goal of preventing data corruption more reliably,
I think.


-- 
Tomas Styblo <tripie@cpan.org>
