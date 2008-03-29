Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYC2Mgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYC2Mgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 08:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYC2Mgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 08:36:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:48908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYC2Mgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 08:36:40 -0400
From: Andreas Schwab <schwab@suse.de>
To: Ketil Froyn <ketil@froyn.name>
Cc: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       linux-kernel@vger.kernel.org
Subject: Re: unexpected rename() behaviour
References: <47ED8858.9000401@froyn.name> <20080329011656.7c38265a@werewolf>
	<47EE2072.7000504@froyn.name>
X-Yow: I have nostalgia for the late Sixties!  In 1969 I left my laundry with
 a hippie!!  During an unauthorized Tupperware party it was chopped &
 diced!
Date: Sat, 29 Mar 2008 13:36:38 +0100
In-Reply-To: <47EE2072.7000504@froyn.name> (Ketil Froyn's message of "Sat\, 29
	Mar 2008 11\:56\:50 +0100")
Message-ID: <jesky9g10p.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ketil Froyn <ketil@froyn.name> writes:

> Is this a corner case undefined by POSIX, for instance, or does POSIX
> explicitly say that this is the correct behaviour?

POSIX explicitly requires that behavior.

> So given the case that it is a requirement that oldpath should be removed
> after the rename(), does all software need to check whether oldpath and
> newpath are existing hard links referring to the same file, and if so,
> call unlink(oldpath) instead? I would guess that lots of existing software
> doesn't.

I don't think there are many programs that encounter that situation.
Probably in most cases the new file was created by the program and
guaranteed to be different from the old file.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
