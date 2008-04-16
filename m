Return-Path: <linux-kernel-owner+w=401wt.eu-S1762524AbYDPVRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762524AbYDPVRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYDPVRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:17:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:22998 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYDPVRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uyX+VRS8NTlfAjoZP8J/vph3QujrFt6AE6KKkbaDi1EPdJKNVhgZdZs5IPVLM/7vQhPbIuYBVLffmSk8Qj59RIjIWOSJkIn86s7wwh1GYHOvi6cKG3SwigTSUgPhAZN89Qpfdq2ZtmV2AwByzq77yHcS0L8OU4DKzd7J1Aj8ieM=
Message-ID: <9a8748490804161417n4ad6c1den54ccd302831a66c6@mail.gmail.com>
Date: Wed, 16 Apr 2008 23:17:14 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: sverre@rabbelier.nl
Subject: Re: Reporting bugs and bisection
Cc: git@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "James Morris" <jmorris@namei.org>, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Willy Tarreau" <w@1wt.eu>,
       david@lang.hm, "Stephen Clark" <sclark46@earthlink.net>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Tilman Schmidt" <tilman@imap.cc>,
       Valdis.Kletnieks@vt.edu, "Mark Lord" <lkml@rtr.ca>,
       "David Miller" <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
       jeff@garzik.org, netdev@vger.kernel.org,
       "David Newall" <davidn@davidnewall.com>
In-Reply-To: <bd6139dc0804160515s64a36748v49556c56d475dda4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FEADCB.7070104@rtr.ca> <48028830.6020703@earthlink.net>
	 <alpine.DEB.1.10.0804131546370.9318@asgard>
	 <20080414043939.GA6862@1wt.eu>
	 <20080414053943.GU9785@ZenIV.linux.org.uk>
	 <20080413232441.e216a02c.akpm@linux-foundation.org>
	 <20080414072328.GW9785@ZenIV.linux.org.uk>
	 <Xine.LNX.4.64.0804150131300.4160@us.intercode.com.au>
	 <4804765B.2070300@davidnewall.com>
	 <bd6139dc0804160515s64a36748v49556c56d475dda4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/2008, Sverre Rabbelier <alturin@gmail.com> wrote:
...
>  Git is participating in Google Summer of Code this year and I've
>  proposed to write a 'git statistics' command. This command would allow
>  the user to gather data about a repository, ranging from "how active
>  is dev x" to "what did x work on in the last 3 weeks". It's main
>  feature however, would be an algorithm that ranks commits as being
>  either 'buggy', 'bugfix' or 'enhancement'.

Interresting. Just be careful results are produced for the big picture
and not used to point fingers at individuals.

>(There are several clues
>  that can aid in determining this, a commit msg along the lines of
>  "fixes ..." being the most obvious.)

One thing I thought of is that the more "Acked-by", "Reviewed-by" and
"Signed-off-by" lines a patch has, the better reviewed we can probably
assume it to be and thus the probability of it having introduced a bug
probably drops slightly compared to other less-reviewed patches... or
maybe not, but at least it's something to think about :-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
