Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbXGFPWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbXGFPWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXGFPVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:21:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:33328 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbXGFPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z5Npb1rMYth4cje+DwPwXirLMTKHye6LbYlolhd2Sd+d1Oc7HzU1arbWXe4uNzaV0vfwkv0FKjsrVHoAi2TaITlEgfHLxbP3vFDz/7t+k7H92cYc9sl7QBwQVycOs/Qn2hgGQwzl5q8tMP0++9oklvyYe/Qm+WeDX4VtVJfWDQM=
Message-ID: <9a8748490707060821m50e53fc2uba2552ea2e0d07a2@mail.gmail.com>
Date: Fri, 6 Jul 2007 17:21:53 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Douglas W. Jones" <jones@cs.uiowa.edu>
Subject: Re: [PATCH 2/2] vsprintf.c: optimizing, part 2: base 10 conversion speedup, v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6F17353B-D428-462B-B318-2FDEC11E8D66@cs.uiowa.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707051251.52891.vda.linux@googlemail.com>
	 <20070705143419.f214f5b2.akpm@linux-foundation.org>
	 <6F17353B-D428-462B-B318-2FDEC11E8D66@cs.uiowa.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/07, Douglas W. Jones <jones@cs.uiowa.edu> wrote:
>
> On Jul 5, 2007, at 4:34 PM, Andrew Morton wrote:
>
> > On Thu, 5 Jul 2007 12:51:52 +0200
> > Denis Vlasenko <vda.linux@googlemail.com> wrote:
> >
> >> Using code from
> >>
> >> http://www.cs.uiowa.edu/~jones/bcd/decimal.html
> >> (with permission from the author, Douglas W. Jones)
> >
> > Neither of your patches had signed-off-by:s.  Would prefer that
> > they were
> > included please, given that we're adding stuff from someone's website.
>
> The material on my website was somewhere between pseudocode and
> code.  The web site is tutorial in nature, and what Vlasenko did
> is follow my tutorial and adapt a working chunk of code from the
> many code snippets in the tutorial.
>
> If a signoff from me is required, someone will need to tell me how,
> since I have no experience with the protocols for Linux code
> development.  I am entirely content with the current form of credit
> given to me in the code (a comment with a pointer to my web site).
>
Section 12 of Documentation/SubmittingPatches :

"
12) Sign your work

To improve tracking of who did what, especially with patches that can
percolate to their final resting place in the kernel through several
layers of maintainers, we've introduced a "sign-off" procedure on
patches that are being emailed around.

The sign-off is a simple line at the end of the explanation for the
patch, which certifies that you wrote it or otherwise have the right to
pass it on as a open-source patch.  The rules are pretty simple: if you
can certify the below:

        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.

then you just add a line saying

        Signed-off-by: Random J Developer <random@developer.example.org>

using your real name (sorry, no pseudonyms or anonymous contributions.)

Some people also put extra tags at the end.  They'll just be ignored for
now, but you can do this to mark internal company procedures or just
point out some special detail about the sign-off.
"


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
