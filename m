Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbXLCNua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbXLCNua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXLCNuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:50:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:45916 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbXLCNuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=joz+IBMmcGM8OMhewWE2jPeOh06KndJmgnQVnLqtYIUZwM5Z3IhEaH/Galx4jpTmYJHJVNgJAiOJ05CZV9s223l8pYLhsrlTbJMyO+Ha9XnYtWTKC3bCMkh0uKxHOop3dP+Ycngjb9rHpojj2aQYhptPqLlvxgmUMqu9skBu4R4=
Message-ID: <84144f020712030550x1cb4dac7q8eeb111f7784590d@mail.gmail.com>
Date: Mon, 3 Dec 2007 15:50:15 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Radoslaw Szkodzinski" <lkml@astralstorm.puszkin.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20071203121357.GB2986@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071202204725.GA25891@one.firstfloor.org>
	 <20071203000741.GB26636@one.firstfloor.org>
	 <20071202165913.3eaebee6@laptopd505.fenrus.org>
	 <20071203095501.GB28560@one.firstfloor.org>
	 <20071203111520.33ed2139@astralstorm.puszkin.org>
	 <20071203102715.GC28560@one.firstfloor.org>
	 <20071203103815.GA2707@elte.hu>
	 <20071203110412.GD28560@one.firstfloor.org>
	 <20071203115900.GB8432@elte.hu>
	 <20071203121357.GB2986@one.firstfloor.org>
X-Google-Sender-Auth: 4f842441ebf7491e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 03, 2007 at 12:59:00PM +0100, Ingo Molnar wrote:
> > "audit thousands of callsites in 8 million lines of code first" is a
> > nice euphemism for hiding from the blame forever. We had 10 years for it

On Dec 3, 2007 2:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Ok your approach is then to "let's warn about it and hope
> it will go away"

It's more like "lets warn about it and fix the problems when we find
some." Btw, how is this different from how the lockdep patches went
in?

                                Pekka
