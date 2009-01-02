Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbZABU0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbZABU0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZABUZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:25:59 -0500
Received: from main.gmane.org ([80.91.229.2]:37164 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZABUZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:25:58 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
   2008-2009
Date: Fri, 02 Jan 2009 14:25:45 -0600
Message-ID: <495E7849.4030706@shaw.ca>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>, burdell@iruntheinter.net
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <20090102210430.49649261@diego-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> El Fri, 2 Jan 2009 13:25:38 -0600, "Linas Vepstas" <linasvepstas@gmail.com> escribió:
> 
>> Suspect its an kernel race condition triggered by ntp bumping the second.
> 
> How could I create a test case that reproduces what ntp does? Just add
> a second?

I'd think that setting the clock to just before midnight on Dec.31 and 
using the adjtimex syscall to set the TIME_INS state on the clock, then 
waiting until midnight rolls around would be a reasonable test..

