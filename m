Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYH2ITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYH2ITV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYH2ITJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:19:09 -0400
Received: from mx03.syneticon.net ([87.79.32.166]:3544 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYH2ITI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:19:08 -0400
Message-ID: <48B7B0F3.1050601@wpkg.org>
Date: Fri, 29 Aug 2008 10:18:59 +0200
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

> In short - I've got bunch of applications running both on windows and linux and these applications \
> exchange links to files mounted on both sides. The problem is that these paths are different, i.e. like \
> D:/dir/file on windows and /mountpoint/dir/file on Linux. What I need is unifying them. So my idea is to \
> have path translator on anything on kernel level, which will make Linux open call to D:/dir/file on Linux \
> work and open /mountpoint/dir/file. Was anything close to that ever incorporated in kernel?

What's wrong with just:

# mkdir -p /D:/dir
# mount.cifs ...
# touch /D:/dir/file

?

Or, use symlinks from /D:/dir to /mountpoint/dir/


-- 
Tomasz Chmielewski
http://wpkg.org

