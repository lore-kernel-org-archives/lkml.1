Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbXLaSIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbXLaSIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXLaSHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:07:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:15039 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbXLaSHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pvZ5Fu5IrUnsm57AzbSq1QbO6mqVBcOLjsStnNustKF4LfgFTMYKTZ9F5eWNiB69ATQ5NXzobPkcoe9Vi847dMK75DnOeeKm0r3CBI7hnfM8/YdPThvxf9jloZpCU1YnbKLTnYz5LfrkqJ9OQB5lm4dzsQvzySe2yT+rVZyHOnU=
Message-ID: <e5bfff550712311007j1cd8223es51b6a59dfb958193@mail.gmail.com>
Date: Mon, 31 Dec 2007 19:07:50 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [ANNOUNCE] qgit-2.1 and qgit-1.5.8
Cc: "Filippo Zangheri" <filippo.zangheri@yahoo.it>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Git Mailing List" <git@vger.kernel.org>
In-Reply-To: <47792B3E.60509@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550712302335ie96e143g55c93e984fba6aaa@mail.gmail.com>
	 <4778CB78.2010906@yahoo.it>
	 <e5bfff550712310358g347d883fm9866f328f24e3ad0@mail.gmail.com>
	 <47792B3E.60509@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 31, 2007 6:47 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Mon, Dec 31 2007 at 13:58 +0200, "Marco Costalba" <mcostalba@gmail.com> wrote:
> > On Dec 31, 2007 11:59 AM, Filippo Zangheri <filippo.zangheri@yahoo.it> wrote:
> >> Hi,
> >>
> >> I git-cloned qgit-2.1 from your repository, then ran `qmake qgit.pro`, but `make` gave me errors.
> >
> > Yes, you need qmake of Qt4 not the Qt3 one.
> >
> <snip>
>
> A Theoretical question.
> Is it possible to compile Qt4 app all statically linked and run it on a Qt3 based KDE
> machine. Some thing like the windows installation, where every thing is self-contained?
>

It's also very practical...I have _only_ KDE 3 installed, not KDE 4 ;-)

I have both Qt4 and Qt3 development (shared) libraries installed and
there is absolutely no compatibility problem, the only thing you have
to remember is when running

qmake qgit.pro

the first time, you need to be sure is the Qt4 qmake, not the Qt3.
Because I have Qt3 qmake in path, not the Qt4 one, I need to
explicitly give the whole path the first time I configure the sources,
something like

/usr/lib/qt4/bin/qmake qgit.pro

Then no other settings are needed, when you call make, the Makefiles
are already built by qmake to search for the correct libraries.


Hope this helps...

Marco
