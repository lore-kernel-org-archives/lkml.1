Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZAEXAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZAEXAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZAEW7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:59:39 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:52276 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZAEW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:59:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CCJVaByhCRQ0Xvq53wmyQigSJhs0dIXab1go6rexCzdZgtybA3zieufmJpVn2uPIwx
         jno7oMIoH9zMPY46pNe8IqEUmVvTXt4UyeKVfaqnNolMRFr+l3l4oESAvkOwMAsi3inr
         sHA2K5Ws2hSBDoF5r9uydAC8k3hf/LKEG+tms=
Subject: Re: [PATCH] module: clean up initialization of variable
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901051523370.25066@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org>
	 <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com>
	 <20090105195415.GA6204@uranus.ravnborg.org>
	 <alpine.DEB.1.10.0901051523370.25066@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 14:59:24 -0800
Message-Id: <1231196364.11902.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 15:30 -0500, Steven Rostedt wrote:
> +	hdr = vmalloc(len);
> +	if (hdr == NULL)

A bit pedantic but,

if (!hdr) perhaps?

Cheers,

Harvey

