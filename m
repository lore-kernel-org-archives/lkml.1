Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYHLUZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYHLUZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYHLUZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:25:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbYHLUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:25:37 -0400
Date: Tue, 12 Aug 2008 13:25:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] h8300 move header files
In-Reply-To: <87myjiq960.wl%ysato@users.sourceforge.jp>
Message-ID: <alpine.LFD.1.10.0808121322190.3462@nehalem.linux-foundation.org>
References: <871w0wvgng.wl%ysato@users.sourceforge.jp> <20080811170534.22f26b7e.akpm@linux-foundation.org> <20080812051101.GA21095@uranus.ravnborg.org> <87myjiq960.wl%ysato@users.sourceforge.jp>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Aug 2008, Yoshinori Sato wrote:
> 
> My h8300 repository can't public access.
> Also difficult pull request.

The nice thing about git is that it doesn't care one whit how something 
gets moved. So you can

 - just send me a regular patch (as a git user, it can be the "git 
   shorthand" kind of patch that has explicit renames, but it can be a 
   traditional patch with delete/create pairs too, and git won't care AT 
   ALL because the end result is the same)

 - or just send me a shell script to do the renames along with a small 
   patch to fix up any other issues that happen as a result of the rename, 
   and a explanation for me to use as a commit message.

Renames in git do not have to be handled as "git" events, unlike many 
other broken models. Git will do the right thing regardless.

			Linus
