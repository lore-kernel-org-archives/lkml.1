Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXGVFHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXGVFHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXGVFHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:07:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:51936 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbXGVFHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aJ/GZgGGreFX3pd8wLBbyJSeVbcYA/CWt0hpRsFsNbWUxkiKku0JUh2cAuuXZXKB/M3wlqJztCzsJJofwgfRwVN1eq5gTjcUnq/5iEYYoskMT5Mj2kgiQ4/a6fedSR7Furv4A4MZSvSsQVuK3iRmq0MOGfOFeh65HB5JsXMNRzA=
Message-ID: <9a8748490707212207h63abdb94o3d27a24d67a0ca12@mail.gmail.com>
Date: Sun, 22 Jul 2007 07:07:32 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH][24/37] Clean up duplicate includes in kernel/
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rickard Faith" <faith@redhat.com>,
       "Eric Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
       "David Woodhouse" <dwmw2@infradead.org>, linux-audit@redhat.com,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "Manfred Spraul" <manfred@colorfullife.com>,
       "Paul McKenney" <paulmck@us.ibm.com>,
       "Josh Triplett" <josh@freedesktop.org>,
       "Stephen Tweedie" <sct@redhat.com>,
       "Shailabh Nagar" <nagar@watson.ibm.com>,
       "john stultz" <johnstul@us.ibm.com>,
       "Christoph Lameter" <clameter@engr.sgi.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <a781481a0707211844s40e203c4t51250ff421d8781d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211703.30346.jesper.juhl@gmail.com>
	 <a781481a0707211844s40e203c4t51250ff421d8781d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/21/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > Hi,
> >
> > This patch cleans up duplicate includes in
> >         kernel/
> >
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
> Reviewed-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>
> [ Jesper, I hope you re-built with all these changes? Some
> of these duplicate #include's could have been hiding deeper
> header-include-ordering problems, and we'd want to know
> about that too. Otherwise looks fairly obvious, thanks. ]
>
I build an allmodconfig kernel, an allnoconfig one as well as one with
my regular config for my home machine.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
