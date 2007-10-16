Return-Path: <linux-kernel-owner+w=401wt.eu-S933478AbXJPHrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbXJPHrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbXJPHrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:47:32 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:58375 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbXJPHrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:47:32 -0400
From: Wagner Ferenc <wferi@niif.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RocketPort Linux driver errors on module reload
References: <bububu786234897832@pripojeni.net> <87k5pozgb5.fsf@tac.ki.iif.hu>
	<4713BAD0.9020606@gmail.com>
Date: Tue, 16 Oct 2007 09:47:28 +0200
In-Reply-To: <4713BAD0.9020606@gmail.com> (Jiri Slaby's message of "Mon, 15
	Oct 2007 21:09:04 +0200")
Message-ID: <87myujsdpr.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Anyway the driver faces another problem with pci refcounting (it
> doesn't increment the counter) and the device might be removed from
> it any time the pci bus code decides.

That doesn't sound too good...  Do you mean the module could stop
working any time, even if its devices are being used continuously?

> Are you willing to test to-pci-probing patches (i.e. patches which
> converts the driver to the model introduced in linux 2.4)?

Well yes.  We've got a copule of such cards, which raises some
interest in a proper driver.  Just send the patches with some
instructions along, or point me to a git branch if you prefer.

> If not, I'll only increment the counter on modprobe and decrement it
> on rmmod, since it would be a safe (in the meaning of not changing
> that much code) way of fixing the problem.

And what are the drawbacks of this simple solution?
-- 
Regards,
Feri.
