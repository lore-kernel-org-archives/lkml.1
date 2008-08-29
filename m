Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYH2IvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYH2IvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYH2IvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:51:00 -0400
Received: from mx03.syneticon.net ([87.79.32.166]:1307 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYH2Iu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:50:59 -0400
Message-ID: <48B7B86B.8090104@wpkg.org>
Date: Fri, 29 Aug 2008 10:50:51 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: alan-jenkins@tuffmail.co.uk, kovlensky@interia.pl
Subject: Re: mounting windows shares with path exactly like on windows
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:

> Tomasz Chmielewski wrote:
>>> In short - I've got bunch of applications running both on windows and
>>> linux and these applications \
>>> exchange links to files mounted on both sides. The problem is that
>>> these paths are different, i.e. like \
>>> D:/dir/file on windows and /mountpoint/dir/file on Linux. What I need
>>> is unifying them. So my idea is to \
>>> have path translator on anything on kernel level, which will make
>>> Linux open call to D:/dir/file on Linux \
>>> work and open /mountpoint/dir/file. Was anything close to that ever
>>> incorporated in kernel?
>>
>> What's wrong with just:
>>
>> # mkdir -p /D:/dir
>> # mount.cifs ...
>> # touch /D:/dir/file
>>
>> ?
>>
>> Or, use symlinks from /D:/dir to /mountpoint/dir/
> That only works from the root directory though.  In unix, "C:/" is a
> relative path.

Yeah, creating "C:" symlink in each and every directory accessed by the 
application doesn't sound like a neat solution.

BTW, it's the first time I hear about a unix application which has paths 
like D:/ or C:/ hardcoded.


-- 
Tomasz Chmielewski
http://wpkg.org
