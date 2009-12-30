Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZL3HRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZL3HRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 02:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZL3HRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 02:17:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56670 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZL3HRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 02:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=k9RV76ccAXlycVz4XHw7iozMLf2RuQUQLTVj3Sc8JNt/NYTc5kxDlI4+91HOuMV6QY
         TtP0Hyrjjox1eTK0NL5TUbYxJ7nEhkrLnPFlNZ/0asm6hiIUNyNGFQrmw4sXFf/cTYkM
         rBHqaHsZ1dGWnD1csz4Mwmg1xKuHBQSm5pZao=
To: "Luke-Jr" <luke@dashjr.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe \(Nokia-D\/Helsinki\)" <felipe.balbi@nokia.com>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
References: <200912290152.16357.luke@dashjr.org>
	<873a2uxip9.fsf@purkki.valot.fi> <200912291505.51230.luke@dashjr.org>
	<200912292110.42122.luke@dashjr.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 30 Dec 2009 09:17:11 +0200
In-Reply-To: <200912292110.42122.luke@dashjr.org> (Luke-Jr's message of "Tue\, 29 Dec 2009 21\:10\:27 -0600")
Message-ID: <87pr5xvslk.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luke-Jr" <luke@dashjr.org> writes:

> On that topic, is there a reason the newer code is under a unified "N8x0" 
> config option instead of the split N800/N810 that was used for the old code, 
> or is that simply a symptom of the currently-supported features all being 
> common?

IIRC, I just used one common n8x0 file because the n810 board file was
very small and I didn't see any benefit from having it separately.

-- 
Kalle Valo
