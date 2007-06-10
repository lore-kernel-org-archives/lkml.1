Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbXFJQUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbXFJQUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXFJQUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:20:09 -0400
Received: from ns.suse.de ([195.135.220.2]:33705 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXFJQUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:20:08 -0400
Date: Sun, 10 Jun 2007 09:22:21 -0700
From: Greg KH <gregkh@suse.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>, linux-kernel@vger.kernel.org,
       m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Message-ID: <20070610162221.GA12830@suse.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 02:24:51PM +0200, Jesper Juhl wrote:
>  On 10/06/07, Tsugikazu Shibata <tshibata@ab.jp.nec.com> wrote:
> > Hi all,
> >
> > I am posting Documentation/HOWTO which is translated into Japanese at
> > bottom of this email.

Great, thanks for posting this and doing the work.

> > This document had been reviewed by JF project which has long history
> > to translate documents into Japanese. (not only kernel but also FAQs).
> > For JF, please see : http://www.linux.or.jp/JF/index.html
> > Please also note that the page is written in Japanese, but you can see
> > a lot of results there.
> >
> > Actually, this is my first trial to post Japanese translated document
> > and here are some points I decided ;
> >
> > - Character encoding is ISO-2022-JP, which is normally used for email
> >   using Japanese.
> 
>  I think there's consensus that documents in the kernel source should
>  be either plain ASCII or UTF-8 (doesn't UTF-8 work for japanese?).

Is it hard to convert it to UTF-8?

> > - Added "Singed-off-by" line
> > - Left the JF header strings which include translator/reviewer's name
> > - Non-patch format, simple text
> >
> > I would be happy if I could get your comments and suggestions.
> > Though I know there are several issues to merge it, I want to have
> > discussions with you to accomplish it.
> >
> > This email comes from strong recommendation from Greg K-H when he came
> > to Tokyo two weeks ago. Thanks >Greg
> >
> > ----- Below lines are Japanese Translation of "HOWTO" -----
> >
> > Signed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
> > ---
> 
>  Unfortunately I don't speak japanese so I can't say anything about the
>  translation at all, but I do have some other comments/questions.
> 
>  If we start adding translated versions of documentation to the kernel
>  source how should we organize the documents? Should each language get
>  a sepperate directory in Documentation/ - like Documentation/JP/,
>  Documentation/EN/, Documentation/DA/ etc?
> 
>  With multiple translated versions of the documentation in the tree,
>  don't we run the risk that the translations will quickly become
>  outdated since most people updating the documentation won't be able to
>  update the translations?

That's up to the people maintaining the translations to do.

>  Since the common language of most kernel contributors is english I
>  personally feel that we should stick to just that one language in the
>  tree and then perhaps keep translations on a website somewhere. So the
>  authoritative docs stay in the tree, in english, so that as many
>  contributors as possible can read and update them. It would then be a
>  seperate project to generate translations and keep them updated
>  according to what's in the tree.  Perhaps we could get the kernel.org
>  people to create an official space for that and then place a pointer
>  to that site in Documentation/ somewhere.

No, I think the translated files should be in the tree proper, we have
the space :)

thanks,

greg k-h
