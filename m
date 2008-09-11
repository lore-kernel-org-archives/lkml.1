Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYIKGUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYIKGUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 02:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYIKGUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 02:20:23 -0400
Received: from wbmler1.mail.xerox.com ([13.13.138.216]:37005 "EHLO
	wbmler1.mail.xerox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYIKGUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 02:20:23 -0400
X-Xerox-Source-Ip: 13.151.210.15
X-Xerox-Source-Name: usa7061gw002.na.xerox.net
X-Xerox-Reported-Name: USA7061GW002.na.xerox.net
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: FW: [linux-pm] select with timeout across S3
Date: Thu, 11 Sep 2008 02:17:10 -0400
Message-ID: <556445368AFA1C438794ABDA8901891C0646024D@USA0300MS03.na.xerox.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: FW: [linux-pm] select with timeout across S3
Thread-Index: AckL+8QHj6Tx6hsyRbS6O8Tijb4RUQH2kH28
References: <556445368AFA1C438794ABDA8901891C09639B7A@USA0300MS03.na.xerox.net> <20080901062513.GA9851@ucw.cz>
From: "Leisner, Martin" <Martin.Leisner@xerox.com>
To: "Pavel Machek" <pavel@suse.cz>
Cc: <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       <martyleisner@yahoo.com>
X-OriginalArrivalTime: 11 Sep 2008 06:20:07.0248 (UTC) FILETIME=[6F911D00:01C913D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I finally got 2.6.27-rc5 running...no change in my test program...

I'm going to look at the patches we're using for 2.4.20/2.6.20...
 
marty


-----Original Message-----
From: Pavel Machek [mailto:pavel@suse.cz]
Sent: Mon 9/1/2008 2:25 AM
To: Leisner, Martin
Cc: linux-kernel@vger.kernel.org; linux-pm@lists.linux-foundation.org
Subject: Re: FW: [linux-pm] select with timeout across S3
 
Hi!

> The behavior of linux (in both 2.4.x and 2.6.x) is when the processor
> sleeps, timeouts on select don't take into account the sleep time,
> only the run time.
> 
> For example, this program should pause for 10 minutes -- however
> if we go into S3 in the middle its pausing for (10 minutes + time in
> S3)
> 
> I saw this on both 2.6.20 and 2.6.22...

Can you test this on 2.6.27-rc? We did have some fixes in that
area....

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

