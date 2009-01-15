Return-Path: <linux-kernel-owner+w=401wt.eu-S1764586AbZAOSwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764586AbZAOSwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZAOSwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:52:30 -0500
Received: from mail2.shareable.org ([80.68.89.115]:53507 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZAOSw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:52:29 -0500
Date: Thu, 15 Jan 2009 18:52:24 +0000
From: Jamie Lokier <jamie@shareable.org>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090115185224.GB5440@shareable.org>
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <20090102094934.GB17841@infradead.org> <495DE995.1070002@opensde.org> <yw1x3ag2t2gd.fsf@thrashbarg.mansr.com> <496F3344.9060104@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <496F3344.9060104@draigBrady.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pádraig Brady wrote:
> > The $(( ... )) construct is standard POSIX shell syntax, see
> > http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html#tag_02_06_04
> > 
> > Bash supports $[ ... ] as an alternate syntax for the same thing.
> > Perhaps you were thinking of that.
> 
> I think the misconception that $(( ... )) is a bashism is caused by
> the wrong highlighting defaults chosen by vim.

I think the misconception is because traditional unix bourne shells
don't implement that construct.  I just tried it on a few machines,
and it failed on 4 of them.  Admittedly, the only up to date one is
running Solaris 10; the others are older unixes that you're unlikely
to build Linux on.

-- Jamie
