Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXEKIGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXEKIGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXEKIGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:06:24 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:32858 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXEKIGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:06:20 -0400
Date: Fri, 11 May 2007 10:06:17 +0200
Message-Id: <1783741195@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: jcm@redhat.com
Subject: [RFC] - LXR on kernel.org ? was: Re: What tools to use?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/eGUUcgguvJI/skxz9TcSptdgrYketYBJDAIOMfg8yAY6nb
 eCjMROSd/mioQfCVTRrAcxypcUNX5gN4duGv44/3DFHsx6z/0o=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I like lxr pretty much.
i`m not a programmer, but i often need some information on "what`s the driver version of xyz in latest kernel" or "was this or that feature/patch already being merged" or "i have this line of code in kernel - how does it look in recent kernel , did it change " ?

over the years, i have downloaded tons of kernels for this, very much waste of bandwidth and time - because whenever i need to take a look, i have no recent kernel source around - so i need to download that big thing and go trough that untar orgy. having recent browsable/searchable and easy to find lxr`ed kernel-source online would be really great

i seldom find lxr for current kernels on the net, so i just wonder: 
why not adding a link to every kernel an kernel.org kernel, pointing to recent lxr`ed kernel source - or - even better - make lxr`ed kernel source part of kernel.org (so we have "B V VI 	C Changelog LXR" ) ? 

sure, i know kernel.org itself is very busy, but maybe this can be done via dedicated lxr machine/webserver someone is willing to donate !?
for myself, i would happily donate some bucks for this.

roland



List:       linux-kernel
Subject:    Re: What tools to use?
From:       "Jesper Juhl" <jesper.juhl () gmail ! com>
Date:       2007-05-09 23:16:01
Message-ID: 9a8748490705091616m584b2249jf912da23820d8f7b () mail ! gmail ! com
[Download message RAW]

On 10/05/07, Shahbaz Khan <shaz.linux@gmail.com> wrote:
> All the experts on this list plz let me know of any good cross
> referencing tool for source code navigation. I have tried LXR but its
> not easy to configure for a rookie like me. Anyother as good as LXR?
>
lxr is pretty good (glimpse on its own as well can be useful). If you
don't want to set it up yourself, then you could consider to use the
online version at http://lxr.linux.no/

Another good thing is "make ctags" in the kernel source dir - this
will  let you quickly jump to declarations etc and back with a few
simple keystrokes in editors like vim.
http://www.faqs.org/docs/ldev/0130091154_64.htm
http://applications.linux.com/article.pl?sid=07/01/22/167212&tid=13&tid=47
http://cscope.sourceforge.net/cscope_vim_tutorial.html

"make cscope" is another good option. It'll generate an index usable
by the cscope tool (http://cscope.sourceforge.net/).

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

