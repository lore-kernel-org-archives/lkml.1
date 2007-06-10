Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbXFJMY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbXFJMY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 08:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXFJMYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 08:24:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:65401 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXFJMYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 08:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AODKB3xEUgJLBme3t/DgwQzGr9CtOZWkKM6ephPGRo/Mv2aezU3Vwq3203ny0dqt4V+jyey+1/xAGpJb6jLLwWFY1MmtBEBaYtmaeaJM3XdXbzxmOOXVX5zc5eBtHdPLWjcLslbBt5Fmd49/+PDWJmc1p7MZ99MXpJ8mUcAJzBo=
Message-ID: <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
Date: Sun, 10 Jun 2007 14:24:51 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Tsugikazu Shibata" <tshibata@ab.jp.nec.com>
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, m-ikeda@ds.jp.nec.com
In-Reply-To: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/07, Tsugikazu Shibata <tshibata@ab.jp.nec.com> wrote:
> Hi all,
>
> I am posting Documentation/HOWTO which is translated into Japanese at
> bottom of this email.

Good job. I'm sure a lot of japanese people will appreciate that.

> This document had been reviewed by JF project which has long history
> to translate documents into Japanese. (not only kernel but also FAQs).
> For JF, please see : http://www.linux.or.jp/JF/index.html
> Please also note that the page is written in Japanese, but you can see
> a lot of results there.
>
> Actually, this is my first trial to post Japanese translated document
> and here are some points I decided ;
>
> - Character encoding is ISO-2022-JP, which is normally used for email
>   using Japanese.

I think there's consensus that documents in the kernel source should
be either plain ASCII or UTF-8 (doesn't UTF-8 work for japanese?).

> - Added "Singed-off-by" line
> - Left the JF header strings which include translator/reviewer's name
> - Non-patch format, simple text
>
> I would be happy if I could get your comments and suggestions.
> Though I know there are several issues to merge it, I want to have
> discussions with you to accomplish it.
>
> This email comes from strong recommendation from Greg K-H when he came
> to Tokyo two weeks ago. Thanks >Greg
>
> ----- Below lines are Japanese Translation of "HOWTO" -----
>
> Signed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
> ---

Unfortunately I don't speak japanese so I can't say anything about the
translation at all, but I do have some other comments/questions.

If we start adding translated versions of documentation to the kernel
source how should we organize the documents? Should each language get
a sepperate directory in Documentation/ - like Documentation/JP/,
Documentation/EN/, Documentation/DA/ etc?

With multiple translated versions of the documentation in the tree,
don't we run the risk that the translations will quickly become
outdated since most people updating the documentation won't be able to
update the translations?

Since the common language of most kernel contributors is english I
personally feel that we should stick to just that one language in the
tree and then perhaps keep translations on a website somewhere. So the
authoritative docs stay in the tree, in english, so that as many
contributors as possible can read and update them. It would then be a
seperate project to generate translations and keep them updated
according to what's in the tree.  Perhaps we could get the kernel.org
people to create an official space for that and then place a pointer
to that site in Documentation/ somewhere.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
