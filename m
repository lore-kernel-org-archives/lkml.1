Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXFXU5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXFXU5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFXU5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:57:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:34746 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXFXU5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:57:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KGr6fQrTxXZXCKG2xKiOjgIgdj+CoZiwj8LGTsw0fDkBgYp1hDk2S/iPBO4vaUWxCw92EeHaQa1DZWbhlku9KfU+2kW/di3irQWtFE51AD4bE3LSfsaXNyL/gTsawYen8gDcYB6tTLhauXyCX7DkIggI5vTXSZuflsIlqX/99Sc=
Message-ID: <9a8748490706241357n12d1c158r503fe22a79acfa93@mail.gmail.com>
Date: Sun, 24 Jun 2007 22:57:40 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alberto Gonzalez" <info@gnebu.es>
Subject: Re: Question about fair schedulers
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706231928.22862.info@gnebu.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200706230007.15622.info@gnebu.es>
	 <200706230946.44023.info@gnebu.es>
	 <EC86BD0E-7829-4DBF-864A-795804235C5C@mac.com>
	 <200706231928.22862.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/06/07, Alberto Gonzalez <info@gnebu.es> wrote:
> El Saturday 23 June 2007 18:35:18 Kyle Moffett escribió:
[snip]
> > "PROCESS1 is more important than PROCESS2" is pure policy and must be
> > done from userspace.  We even give appropriate enforcement mechanisms
> > to userspace to take such action (nice levels).
>
> Yes, an app to change priorities would be very nice,

You already have such an app. It is called 'renice' (and 'nice'). Most
people can work out how to use those. :-)

You also have graphical apps to do the job. For example, in KDE, try
starting the "KDE System Guard" application (usually bound to the
CTRL+ESC hotkey) and you'll see a nice list of all running processes.
If you right-click a process you'll get a drop-down box with the
bottom entry being "Renice Process...", simply click that and you can
adjust the priority of that process.  You can also easily make it so
that whenever you start a given application it gets niced to a
specific priority; simply (again assuming KDE) right-click the icon
you use to launch the application and edit it, select the
"Application" tab and in the "Command: " field prefix the command used
to launch the application with 'nice' and the priority you want, save
your changes and the next time you launch that app it'll get the
priority you wish.
Gnome and most other environments also have similar capabilities.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
