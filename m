Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZIKLrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZIKLrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZIKLrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:47:48 -0400
Received: from averell.mail.tiscali.it ([213.205.33.55]:46521 "EHLO
	averell.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbZIKLrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:47:47 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 07:47:47 EDT
From: Giuseppe Scrivano <gscrivano@gnu.org>
To: Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org, bug-coreutils@gnu.org
Subject: Re: extend inotify to support file descriptors in addition to paths
References: <87fxaxvuh6.fsf@master.homenet>
	<7e0fb38c0909100727t51d3d523o403e05a225881403@mail.gmail.com>
Date: Fri, 11 Sep 2009 13:39:38 +0200
In-Reply-To: <7e0fb38c0909100727t51d3d523o403e05a225881403@mail.gmail.com>
	(Eric Paris's message of "Thu, 10 Sep 2009 10:27:25 -0400")
Message-ID: <87k505bthh.fsf@master.homenet>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@parisplace.org> writes:

> On Tue, Sep 8, 2009 at 8:21 PM, Giuseppe Scrivano <gscrivano@gnu.org> wrote:
>
>> at the moment inotify permits to add new files to be watched using their
>> path.  There are situations where the file path is not know but a
>> descriptor is available.  It would be desiderable to have the
>> possibility to use the inotify system even in these (rare) cases.
>
> I don't think specifying the inode in question by fd is fundamentally
> a bad idea.  It is the reason I decided to use fd's when registering
> event's in the upcoming fanotify rather than pathnames.  I do however
> question if we really want to add yet another syscall for inotify.
> We've already seen that inotify is very hard to expand.  The fixed
> message length, lack of information a number of users want, and
> difficultly in extending those things make me reticent to support more
> extentions.

> Personally I'd rather see us/you move to fanotify which is (I hope)
> extensible forever.  If only I could get networking people to review
> it.  Have you looked at fanotify?  I'm going to repost the series in a
> couple minutes, maybe you could tell me if fanotify might work for
> you?

Sure, I'll take a look at it.  I have few questions before look at
details: is it an attempt to replace inotify?  Does fanotify use only
fd?  Have the possibility to watch a file by its path, like inotify
does, is not a bad idea when the file is not already opened.

Thanks,
Giuseppe
