Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbXEIXQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbXEIXQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbXEIXQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:16:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:21809 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331AbXEIXQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MVSAHw3shP7JtKLfywOG2u1yPi+RuZU/85CMUt+lnw9sGVCToJNExlQsr/zcKe8OSIooUal+cMXbAaVkA1vd4ophkW1wxgLQWR03cX/z2FwoklABSx1SxbOILuxQqdLU95pOFl/xOXQm8MbLU5u39ghs2cVMkGBPkCZKTYby3/o=
Message-ID: <9a8748490705091616m584b2249jf912da23820d8f7b@mail.gmail.com>
Date: Thu, 10 May 2007 01:16:01 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Shahbaz Khan" <shaz.linux@gmail.com>
Subject: Re: What tools to use?
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20cbb9450705091557p53e771f6g7cb2c8b0491a3d8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20cbb9450705091557p53e771f6g7cb2c8b0491a3d8a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
