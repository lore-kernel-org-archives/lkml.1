Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756103AbYLQCMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYLQCMh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYLQCM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:12:27 -0500
Received: from sca-ea-mail-4.Sun.COM ([192.18.43.22]:57797 "EHLO
	sca-ea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYLQCM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:12:26 -0500
X-Greylist: delayed 1564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 21:12:26 EST
Message-ID: <494859C9.20305@sun.com>
Date: Tue, 16 Dec 2008 17:45:45 -0800
From: Dan Mick <dan.mick@sun.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Gerd Hoffmann <kraxel@redhat.com>, linux-arch@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>, opensolaris-code@opensolaris.org,
        linux-kernel@vger.kernel.org, opensolaris-rfe@opensolaris.org,
        Ulrich Drepper <drepper@redhat.com>
Subject: Re: [osol-code] [PATCH v2] Add preadv and pwritev system calls.
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <67079b830812150837o12adaa1awe40b0759bbea1f7a@mail.gmail.com> <4946C160.2090505@redhat.com> <200812161057.03025.arnd@arndb.de>
In-Reply-To: <200812161057.03025.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 15 December 2008, Gerd Hoffmann wrote:
>> Jennifer Pioch wrote:
>>> On 12/12/08, Gerd Hoffmann <kraxel@redhat.com> wrote:
>>>> Free- and OpenBSD have it too.  For Solaris I've found a feature request
>>>>  only.  Dunno about MacOS/Darwin.  Other un*xes which are important these
>>>>  days?
>>> Do you know the ID of the feature request?
>> #1167819 @ bugs.opensolaris.org
>>
> 
> Looks like they've been working on it for some time:
> "Submit Date   25-MAY-1994"!
> 
> 	Arnd <><

No one's expended any serious time on it at all, it looks like, other than 
discussion.

I see the one comment says that it can be done with lio_listio(3RT) (apparently 
in LIO_WAIT mode), and that interface does seem to offer all the preadv/pwritev
functionality.  That's not to say that we shouldn't implement preadv/pwritev 
literally, just that there should be a way to get that sort of functionality today.
