Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759351AbYLQLwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbYLQLwN (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYLQLv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:51:56 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39088 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYLQLvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:51:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PQN5xWfGfZoi/tCWsLuAEAHo/WSiLgAUaNMwJMWEleuYCCrc+X9fPOInFIYl9sNqdo
         F/+NlUmUE9TJndFMspPtQcvlNodY6HpdIjbb8ypahDdnZpoGm8FhtyJRique8/hBkI3a
         gqwzjT4kRm4MAf+n7hoIvNofyahhPOO/Qscko=
Message-ID: <aa79d98a0812170351rb64c595gc933456c661317c5@mail.gmail.com>
Date: Wed, 17 Dec 2008 14:51:53 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Subject: Re: [PATCH last/many] x86: checking framework for correct use of ENTRY/PROC
Cc: linux-arch@vger.kernel.org,
        "Alexander van Heukelum" <heukelum@mailshack.com>,
        "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <1229505475-10219-3-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
	 <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
	 <1229505475-10219-3-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 12:17 PM, Alexander van Heukelum
<heukelum@fastmail.fm> wrote:
> [ DO NOT APPLY (yet...) At this point this patch will
> just cause the build to abort due to annotation errors
> found. ]
>
> Introduce a checking framework to check correct pairing
> of ENTRY/END and PROC/ENDPROC. It also checks that the
> annotations are not nested. I have used the ideas and
> most of the implementation from Cyrill Gorcunov who
> introduced the framework to check for mismatching
> KPROBE_ENTRY annotations, which was however soon made
> obsolete by the removal of KPROBE_ENTRY/KPROBE_END.
>
> Checks performed:
>  o  END must terminate an ENTRY annotation
>  o  ENDPROC must terminate a PROC annotation
>  o  ENTRY or PROC cannot be nested inside
>        another ENTRY or PROC section.
>
> Finally the macro ENTRY_PROC_FINAL is introduced to
> enable checking correct closing of PROC and ENTRY
> sections at the end of assembly files.
>
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
...

Thanks Alexander!

You know I think you meant __ASSEMBLY__ while
were typing __ASSEMBLER__. Don't you? :)
