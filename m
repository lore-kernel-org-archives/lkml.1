Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYAETuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYAETuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYAETup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:50:45 -0500
Received: from ns1.suse.de ([195.135.220.2]:52047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYAETuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:50:44 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
References: <je3atcjd1v.fsf@sykes.suse.de>
	<1199561709625@dmwebmail.japan.chezphil.org>
X-Yow: YOU'D cry too if it happened to YOU!!
Date: Sat, 05 Jan 2008 20:50:43 +0100
In-Reply-To: <1199561709625@dmwebmail.japan.chezphil.org> (Phil Endecott's
	message of "Sat\, 05 Jan 2008 19\:35\:09 +0000")
Message-ID: <jey7b4hx0s.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:

> Sorry for being dense, but what is the implication of your comment "Since
> it isn't restarted" ?  Are you saying that the kernel isn't going to
> restart it and will have converted it to EINTR and returned that to
> user-space, and that this modified return value is not reported by strace?

Yes, assuming there was a signal handler and it wasn't registered with
SA_RESTART.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
