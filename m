Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZKSSgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZKSSgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZKSSgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:36:05 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54912 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZKSSgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:36:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s7rV92EHYUdC0dNwGr8PIZljFazX7NXmRGJLmLdQ8gzgicJnuTjbwcg9TdFGghIb8a
         81sg7tKG0dlYAHsNcNeaHojR5X8JPREcsYn8PXRthb8Zrki63ioZB2u+l88+jhFDOqcL
         HPntrhLtN6qJsZLCNlmS62Q1+sWPf/+cQ8gws=
MIME-Version: 1.0
In-Reply-To: <1258655585.22249.751.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <4B058C76.9090609@redhat.com>
	 <1258655585.22249.751.camel@gandalf.stny.rr.com>
Date: Thu, 19 Nov 2009 10:36:08 -0800
Message-ID: <de8d50360911191036s2f7a1da7p8da59ab248c77d11@mail.gmail.com>
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Andrew Pinski <pinskia@gmail.com>
To: rostedt@goodmis.org
Cc: Andrew Haley <aph@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 10:33 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> It has to align the entire stack? Why not just the variable within the
> stack?

I had proposed a patch which just aligns the variable but that patch
was never really commented on and HJL's patches to realign the whole
stack went in afterwards.

Thanks,
Andrew Pinski
