Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZDABoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZDABoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZDABoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:44:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:8191 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZDABo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=S2oeKYoX+bTQ0IK3gECe1bP1iUhtFeNiIoKlqaEE22iN93okmQLpfB3VyP9id2FXHu
         v49Nk/JR2WPSKsJgoKWn2RX1F8aP3PrBepaCjYF2/UwadAhrJHIY2m1rvggs3gwzKSKD
         HEHTxp1W651/oDaRFfYFzNNBmH7OIW1pC3thc=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090401012547.3B581FC3AB@magilla.sf.frob.com>
References: <20090324102516.459441533@linutronix.de>
	 <20090331152610.GC4792@redhat.com>
	 <cfd18e0f0903311816p27a7b8c3jd62e563f4c95299e@mail.gmail.com>
	 <20090401012547.3B581FC3AB@magilla.sf.frob.com>
Date: Wed, 1 Apr 2009 14:44:26 +1300
Message-ID: <cfd18e0f0903311844nd5ab221g6bff6cf5fc73de42@mail.gmail.com>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall -V2
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 2:25 PM, Roland McGrath <roland@redhat.com> wrote:
>> 1) With rt_siqueueinfo(), we can get the PID (TGID) of the sender,
>
> No.  You can get whatever the caller put into the siginfo_t.
> Only the si_signo field is set by the kernel.
>
>> With rt_tgsigqueueinfo(), [...]
>
> You still get whatever the caller put into the siginfo_t.

Yes.  I wrote the text awkwardly, but I think the point was clear.  In
my point 1, I wrongly thought we needed a way to get the sender's TID
to the receiver, and you pointed out that sigval could do the job.  In
my point 2, I made the same observation as you just made above.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
