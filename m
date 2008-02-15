Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYBOXKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYBOXKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYBOXJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:09:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:29991 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYBOXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=sKHsk3jQmiXGH2ZrVkURXoKof0rD4U8AePfkY5go6tBfncxMWFY5pgKYulgclceC9xswS+P17+AMuc74/wTBrfriRYLfwT/zlmydZIGkwyrVoOUqTfSRpSMrbyqE+hilBemA6AYMWOvJTUxM3z9MSb5syOK9gp4aGzYultcJwC8=
Date: Sat, 16 Feb 2008 01:07:22 +0200
To: Andreas Schwab <schwab@suse.de>
Cc: libc-alpha@sourceware.org, libc-alpha@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux i386 clone(): %ebx 'frobbing' ?
Message-ID: <20080215230722.GA8012@ubuntu>
References: <20080215184228.GA6687@ubuntu> <jewsp69e5t.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jewsp69e5t.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Fri, Feb 15, 2008, Andreas Schwab wrote:
> "Ahmed S. Darwish" <darwish.07@gmail.com> writes:
> 
> > I don't understand how the `fn' argument reached the child thread
> > in the %ebx register. It's said in the comment that `fn' will be
> > popped to child 'in the ebx frobbing below'. But what does that mean ?
> 
> See "popl %ebx" after "int $0x80".
> 

I hope I'm not misreading something obvious, but I can't find
the code where FUNC(%esp) is stored in %ebx before %ebx value
got pushed in the stack (and restored in above 'popl' statement).

Thanks a lot for help.

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

