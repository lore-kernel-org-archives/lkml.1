Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZBEEzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZBEEzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 23:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZBEEz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 23:55:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:56070 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZBEEz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 23:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qgp046P2lIAVdm1jf3aCvplFwWzFWWci6HNEYm5CpV/ecksCHOj2FkMuAm3TcMbL1P
         cSOv2gnWcETdBftMnwYQPGSYwZcQljB20OG4u7pwE/wLt8hKvsA3eyVUP5iwmbKuo8S8
         gZd+bYA/QQ9b8a+IIDH5o4Nas+TwvJJXd5XGA=
MIME-Version: 1.0
In-Reply-To: <20090205030553.49650FC381@magilla.sf.frob.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	 <20090201174159.4a52e15c.akpm@linux-foundation.org>
	 <20090202064509.GA20237@redhat.com>
	 <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	 <20090202165606.GA13346@redhat.com>
	 <20090205030553.49650FC381@magilla.sf.frob.com>
Date: Wed, 4 Feb 2009 20:55:26 -0800
Message-ID: <3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 7:05 PM, Roland McGrath <roland@redhat.com> wrote:
> I haven't seen the clear explanation of what specific actual problems there
> are here.  But I'm quite sure this is not the right approach to address them.
>
> Kaz has said things that seemed to imply that the behavior is erratic or
> the semantics are somehow ill-defined when the group leader has died with
> other threads living on.  In fact, this case is perfectly well-specified
> and there is no mystery about it.

I haven't observed anything that could be called erratic. The behavior that
occurs, occurs reliably.
