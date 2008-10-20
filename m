Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYJTQvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYJTQvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYJTQvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:51:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44286 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYJTQvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:51:23 -0400
Date: Mon, 20 Oct 2008 11:51:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>, Louis.Rilling@kerlabs.com,
       containers@lists.linux-foundation.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrey Mirkin <major@openvz.org>
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Message-ID: <20081020165117.GA25885@us.ibm.com>
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1224286383.1848.65.camel@nimitz> <20081020111002.GQ15171@hawkmoon.kerlabs.com> <48FC86B2.8000606@fr.ibm.com> <48FCA97C.1040108@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FCA97C.1040108@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> This is a misconception: my patches are not "internal checkpoint". My
> patches are basically "external checkpoint" by design, which *also*
> accommodates self-checkpointing (aka internal). The same holds for the
> restart. The implementation is demonstrated with "self-checkpoint" to
> avoid complicating things at this early stage of proof-of-concept.
> 
> For multiple processes all that is needed is a container and a loop
> on the checkpoint side, and a method to recreate processes on the
> restart side. Andrew suggests to do it in kernel space, I still have
> doubts.

Yes I still prefer in-kernel.  Can you elaborate on advantages of doing
more work in userspace?

> While I held out the multi-process part of the patch so far because I

Yup, and i appreciate your restraint until now :)  It made your patchset
much easier to review.

> was explicitly asked to do it, it seems like this would be a good time
> to push it out and get feedback.

Can you send that out as a patch(set) on top of your v7?  I'd love to
see (and test) it.

thanks,
-serge
