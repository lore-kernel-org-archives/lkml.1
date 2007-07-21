Return-Path: <linux-kernel-owner+w=401wt.eu-S936383AbXGUWPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936383AbXGUWPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935152AbXGUWPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:15:20 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:24564 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934751AbXGUWPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LlSja+4AojaYY0PP0yNdmd+fI+SMCpYHq2qE3MoehKkM7Au92VBOIZ7b6Xi948UXMmEFu9loDMi2zpA8QcEeFBGXor+ptmPZW+Q8p/j8pYcmJE1XvcZWUEnYdaRxnvTeoB5Y+Mp4v3ZyPdlXowLWsxhyJNH8i04P7edZ6R2RKQw=
Message-ID: <8bd0f97a0707211515p46063d20y1aa9007b167ec916@mail.gmail.com>
Date: Sat, 21 Jul 2007 18:15:16 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: More effective processing (Re: [PATCH 25/33] kbuild: use POSIX BRE in headers install target)
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070721221627.GN475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184681344985-git-send-email-sam@ravnborg.org>
	 <118468134441-git-send-email-sam@ravnborg.org>
	 <11846813441741-git-send-email-sam@ravnborg.org>
	 <1184681344376-git-send-email-sam@ravnborg.org>
	 <E1ICAEU-0005an-5F@flower>
	 <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com>
	 <20070721100422.GK475@flower.upol.cz>
	 <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com>
	 <20070721203916.GA2912@uranus.ravnborg.org>
	 <20070721221627.GN475@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> On Sat, Jul 21, 2007 at 10:39:16PM +0200, Sam Ravnborg wrote:
> > On Sat, Jul 21, 2007 at 03:21:43PM -0400, Mike Frysinger wrote:
> []
> > > while you could try and make a claim against memory/cpu effeciency, i
> > > fail to see how the first or last claims could possibly be backed up
>
> Less \{\(\\n\t\+\)\} [0] stuff make readings regex much easier. My
> confusion shows that i didn't used \{ much, because have another ways
> so far. And even after my quick testing i didn't realize that there
> was unrelated to main task whitespace cleanup.

the e-mail text you were quoting was [[:blank:]] vs [[:space:]], not + vs \{1,\}

> ./linux/stat.h:#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)

__GLIBC__ cruft should be cleansed rather than looked at for anything else
-mike
