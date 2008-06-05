Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYFEG4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYFEG4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYFEG4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:56:12 -0400
Received: from lazybastard.de ([212.112.238.170]:52274 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYFEG4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:56:12 -0400
Date: Thu, 5 Jun 2008 08:55:57 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset translation
Message-ID: <20080605065557.GC17037@logfs.org>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <4846E44A.1010601@am.sony.com> <20080604191522.GA18873@uranus.ravnborg.org> <4846EBAE.2000604@am.sony.com> <20080604202314.GG4189@cs181133002.pp.htv.fi> <4846FE3E.4020508@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4846FE3E.4020508@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 June 2008 13:42:38 -0700, Tim Bird wrote:
> Adrian Bunk wrote:
> > I might be wrong, but although monitoring the size makes a lot of sense
> > I don't believe "fully automate the testing ... and send notifications" 
> > will work.
> 
> "fully automate" was sloppy wording on my part.  "automate enough
> to not be a burden to maintain" is what I should have said.

Even that blows.  People all too easily forget about the end-to-end
principle.  If you want a system that scales well, you have to push as
much work as possible to the ends and do as little as possible in the
center.  Applies here as well as in networking.

If CELF funds 20 people to do such tests, they may be able to cope
today.  But the stream of developers keeps swelling, so even those 20
won't be able to cope long-term.  Instead we have to enable everyone in
the stream of developers to easily check for themselves.  If then stream
keeps swelling, the amount of bloat-checking swells along.

What scales well is the "make check*" targets in the source.  Some even
claim it scales too well and attracts too many clueless janitors.  I'd
be happy if we ever get into the same trouble with bloat checking. ;)


Jörn

-- 
Das Aufregende am Schreiben ist es, eine Ordnung zu schaffen, wo
vorher keine existiert hat.
-- Doris Lessing
