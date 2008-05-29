Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbYE2WTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbYE2WTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbYE2WT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:19:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:19116 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYE2WTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SUMWzbVRFouHw0ihnbsEvBqUVXMr6Jphh/6AmPtMCVemYsz+oaNqpY4YmJ4MnqyPKiNJKOlGCEmTeZk+WDl/42g+zwxTMGPSyLe1KZCAPEAqJ02Pp7mmUbT4Ns277LRrG8KJfixSCPHZi7n5Vs1i534dQKhBfkdifYPaymtdjxE=
Message-ID: <9a8748490805291519l18a88d1bj6d5ffa2b88c19b1d@mail.gmail.com>
Date: Fri, 30 May 2008 00:19:23 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: whomto.pl -- finding out whom to send patches to
Cc: linux-kernel@vger.kernel.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Sverre Rabbelier" <alturin@gmail.com>, "Joe Perches" <joe@perches.com>,
       git@vger.kernel.org
In-Reply-To: <20080529210018.GA5508@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080529210018.GA5508@damson.getinternet.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/29 Vegard Nossum <vegard.nossum@gmail.com>:
> Hi,
>
> I've written this perl script that takes a patch as input and prints the
> authors/committers of the affected lines, using git-blame as the back end.
>
> (The purpose of this is of course to find out whom to send patches to.)
>
<snip>

The script is nice, but I'd wish it looked at a few other things as well.

When I personally need to determine who to send patches to I do use
'git blame' for some of the addresses, but in addition to that I also
check;

- The comments at the top of the file.  Sometimes there are email
addresses there for relevant people (sometimes just names, but
addresses can then usually be found for those people in CREDITS or
MAINTAINERS).

- Entries in MAINTAINERS that are relevant to the subsystem and/or
file I'm modifying.

- Entries in CREDITS that look relevant to the subsystem and/or file
I'm modifying.

- Names/email addresses in files in Documentation/ that are relevant
to the subsystem/file I'm modifying.

If the script could be made to check all (or just some) of those
sources as well it would be really great.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
