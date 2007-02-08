Return-Path: <linux-kernel-owner+w=401wt.eu-S1161386AbXBHBTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161386AbXBHBTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161507AbXBHBTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:19:53 -0500
Received: from mail.freedom.ind.br ([201.35.65.90]:44945 "EHLO freedom.ind.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161386AbXBHBTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:19:52 -0500
From: Otavio Salvador <otavio@debian.org>
To: nigel@nigel.suspend2.net
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add PM_TRACE x86_64 support.
Organization: O.S. Systems Ltda.
References: <1170895857.4451.55.camel@nigel.suspend2.net>
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Wed, 07 Feb 2007 23:18:24 -0200
In-Reply-To: <1170895857.4451.55.camel@nigel.suspend2.net> (Nigel Cunningham's
	message of "Thu, 08 Feb 2007 11:50:57 +1100")
Message-ID: <87lkj9bg67.fsf@neumann.lab.ossystems.com.br>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <nigel@nigel.suspend2.net> writes:

> -	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 6) {
> +	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 2 + sizeof(unsigned long)) {

Could you split this line?

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
