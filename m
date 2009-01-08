Return-Path: <linux-kernel-owner+w=401wt.eu-S1763002AbZAHWE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002AbZAHWE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZAHWEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:04:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:1680 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbZAHWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=E4E9/Sonsoxfe496kSOSHdF5RNRYL0jqSZbQhbko/DlBmYdWY1DvDCyHYjHa8Ms2Bj
         XhAvr/ii2FQYE+Ydx+9ZpV9CZiOGSLln+YFMPQlQ6QboWTXKRq0WpePFA5/Qp8rlJ0WD
         9J8rV1SI/Cz5L4RjAujPyEMUQzeyTRRMF9fOg=
Message-ID: <517f3f820901081404x6177b413hfa21f1613ffb4213@mail.gmail.com>
Date: Fri, 9 Jan 2009 11:04:48 +1300
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Roland McGrath" <roland@redhat.com>, "Casey Dahlin" <cdahlin@redhat.com>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
X-Google-Sender-Auth: c328c0e9bb9d9a14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 9:53 AM, Roland McGrath <roland@redhat.com> wrote:
> New syscall should have gone to linux-api, I think.

Yes, precisely.  This requirement has been documented in
SubmittingPatches for several months now.  More details here:
http://thread.gmane.org/gmane.linux.ltp/5658

Casey, *please* don't submit a patch for a system call without also
providing a test program, and some attempt at userspace documentation.
 (Andi already pointed this out.  From my POV, I don't need you to
write a full blown man page -- if you send me the text, I'll do the
*roff stuff.  But that text should accompany the patch that implements
the syscall.)

Cheers,

Michael

>
> Do we really need another one for this?  How about using signalfd plus
> setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead of
> SIGCHLD?  It's slightly more magical for the userland process to know to do
> that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
> really have to add, maybe better.
>
>
> Thanks,
> Roland
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
