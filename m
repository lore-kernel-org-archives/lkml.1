Return-Path: <linux-kernel-owner+w=401wt.eu-S1030476AbXDJITt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbXDJITt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030470AbXDJITt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:19:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33610 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030476AbXDJITr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:19:47 -0400
Message-ID: <461B48A0.5010009@garzik.org>
Date: Tue, 10 Apr 2007 04:19:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: I give up
References: <200704091007.58535.gene.heskett@gmail.com> <1176169246.3193.2.camel@obelisk.thedillows.org> <20070410071217.GA28899@aepfle.de> <200704100351.33699.gene.heskett@gmail.com>
In-Reply-To: <200704100351.33699.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Tuesday 10 April 2007, Olaf Hering wrote:
>> On Mon, Apr 09, Dave Dillow wrote:
>>> It's not /dev he's backing up -- its /home, /usr, and others. GNU tar
>>> saves the device and inode numbers from the {,l}stat() call on each
>>> file and decides it is a new file if either number changes from run to
>>> run.
>> So fix tar to not do silly things.
>> Kernel major:minor numbers are not stable.
> 
> YOU Tell that to the tar/star people, they are flabbergasted that its not 
> stable.  It apparently is for every other OS tar can be run on.

It's just the new world that we live in.

I don't see us ever going back to 100% static major/minors.

Though as a point of history, Linux has /always/ supported dynamic 
major/minor numbers, even back in 0.99 days.  We avoided the problem 
then because the dynamic major/minors were only used by drivers that had 
not yet had static numbers assigned, or their author chose to avoid 
LANANA for some other reason.

	Jeff



