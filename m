Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYD2XGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYD2XGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYD2XF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:05:57 -0400
Received: from 1wt.eu ([62.212.114.60]:3594 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbYD2XF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:05:56 -0400
Date: Wed, 30 Apr 2008 01:05:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429230511.GA18377@1wt.eu>
References: <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429111014.5a065b88@core> <20080429103335.GD1473@1wt.eu> <20080429113410.0971d071@core> <20080429221230.GA17360@1wt.eu> <20080429231554.69973c45@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429231554.69973c45@core>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:15:54PM +0100, Alan Cox wrote:
> > OK I could reproduce the case without ever involving either a shell or
> > readline or anything. Using "cat" as the init program exhibited the
> > anomaly, though it was not much easy to analyze. Then I switched to
> > "init=od -An -tx1 -".
> 
> Did you put the console into utf-8 mode before the cat ?

I had not *explictly* disabled it, since as the doc suggests :

        vt.default_utf8=
                        [VT]
                        Format=<0|1>
                        Set system-wide default UTF-8 mode for all tty's.
                        Default is 1, i.e. UTF-8 mode is enabled for all
                        newly opened terminals.

And I know that I can fix the behaviour by explicitly setting it to zero.
Also, the fact that "od" shows me multi-byte characters on the input
indicates to me that everything is set to UTF-8. So unless I'm missing
something, my console is set by default to UTF-8 (I test this on 2.6.25).

Regards,
Willy

