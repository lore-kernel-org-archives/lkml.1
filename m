Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbYITQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbYITQsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYITQsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:48:15 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:43012 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYITQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:48:14 -0400
Message-ID: <48D5294B.2010804@skyrush.com>
Date: Sat, 20 Sep 2008 10:48:11 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] Fix backspace on wrapped lines in console (virtual terminal)
References: <48D5240D.7070701@skyrush.com> <20080920173822.51794923@lxorguk.ukuu.org.uk>
In-Reply-To: <20080920173822.51794923@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 20 Sep 2008 10:25:49 -0600
> Joe Peterson <joe@skyrush.com> wrote:
> 
>> Attached is a patch that fixes virtual terminal problems when backspace
>> is used on wrapped lines (see patch text for the specific issues).  The
>> issues can be demonstrated by trying two things in the console (vt):
> 
> I would need to power up my vt420 to check (yes I have one lurking in a
> corner!) but I have a feeling the current behaviour (not going up a line)
> is correct for ansi type terminals.

Would it still erase the actual characters input, though?  This would
cause one to believe they were not erased, since the visual feedback
does not match...  I wonder if "fixing" this in Linux would really break
the needed vt hardware compatibility - maybe that case lies in the
"undefined" area in a sense.

What about the need_wrap (end of line) case - I wonder what the real
vt420 does for that.  If it doesn't match the behavior this patch
"fixes", it would probably be a vt420 bug...

Yes, these things are certainly getting harder to check against real
hardware these days!  :)

						-Joe
