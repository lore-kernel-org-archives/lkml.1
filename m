Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYAOH4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYAOH4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 02:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYAOH4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 02:56:37 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:49891 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYAOH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:56:37 -0500
From: Junio C Hamano <junio@pobox.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Fix 32bit build for git-x86
References: <20080115010449.GA5521@basil.nowhere.org>
	<20080115074511.GA15285@uranus.ravnborg.org>
cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Date: Mon, 14 Jan 2008 23:56:23 -0800
In-Reply-To: <20080115074511.GA15285@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Tue, 15 Jan 2008 08:45:11 +0100")
Message-ID: <7vodbnh68o.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

> I wonder how these tabs came in.
> I am almost sure they were not in my original patch. But as git-send-email
> do not save copies of my sent mails I cannot be sure.
>
> Ingo - do you have a script on your side that could have converted
> the spaces to tabs?
> It could be a simple "make checkpatch happy" change too - but in this case
> it was wrong.

"git-apply --whitespace=fix" can also contribute to this issue,
but only when "core.whitespace = indent-with-non-tab" is
explicitly enabled by the user's configuration.


