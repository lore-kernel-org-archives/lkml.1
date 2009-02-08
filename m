Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZBHIsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZBHIsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 03:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZBHIsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 03:48:32 -0500
Received: from imag.imag.fr ([129.88.30.1]:50753 "EHLO imag.imag.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbZBHIsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 03:48:31 -0500
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Feb 2009 03:48:31 EST
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.6.2-rc0
References: <7vvdrlsyjm.fsf@gitster.siamese.dyndns.org>
From: Matthieu Moy <Matthieu.Moy@imag.fr>
Date: Sun, 08 Feb 2009 09:23:03 +0100
In-Reply-To: <7vvdrlsyjm.fsf@gitster.siamese.dyndns.org> (Junio C. Hamano's message of "Sat\, 07 Feb 2009 13\:54\:37 -0800")
Message-ID: <vpqprhte3rs.fsf@bauges.imag.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (imag.imag.fr [129.88.30.1]); Sun, 08 Feb 2009 09:23:04 +0100 (CET)
X-IMAG-MailScanner-Information: Please contact MI2S MIM for more information
X-IMAG-MailScanner: Found to be clean
X-IMAG-MailScanner-SpamCheck: 
X-IMAG-MailScanner-From: moy@imag.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> GIT v1.6.2 Release Notes (draft)
> ================================
>
> With the next major release, "git push" into a branch that is
> currently checked out will be refused by default.  You can choose
> what should happen upon such a push by setting the configuration
> variable receive.denyCurrentBranch in the receiving repository.

Perhaps this paragraph should tell _why_ this is a dangerous
operation. There's probably a better wording, but what about

---- 8< ---
With the next major release, "git push" into a branch that is
currently checked out will be refused by default: Pushing to a
checked-out branch changes the HEAD for this branch, and would confuse
further local operations in the target repository.

You can choose what should happen [...]
---- 8< ---

?

-- 
Matthieu
