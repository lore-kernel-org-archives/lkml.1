Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbXKWOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbXKWOS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 09:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXKWOST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 09:18:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:17083 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbXKWOSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 09:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MZHk1Q4x60xa1GTfSgq8ZJU9HSe/YL81DaajvJRsh0qmt2BD7kUB+eLFr6ktRKAjhop6QeN7IaMnujY5vZgZ8A4Srng1ca/gnK0vnpCqm+AypwWmVHBTVTX2+vPVI/9qVYLLx8Ceb93EyXMqLp7sDH9ivlnZezmr495jKjVPE9o=
Message-ID: <118833cc0711230618n28b3aabi43822838e27e63f6@mail.gmail.com>
Date: Fri, 23 Nov 2007 09:18:16 -0500
From: "Morten Welinder" <mwelinder@gmail.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: Inotify fails to send IN_ATTRIB events
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rlove@rlove.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <118833cc0711221749h2da36d7ek856ee91cdeda955@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
	 <20071122153446.GA6299@atrey.karlin.mff.cuni.cz>
	 <118833cc0711221749h2da36d7ek856ee91cdeda955@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> With this patch I am seeing a endless stream of  IN_IGNORED events
> for a removed watch.

Sorry, that problem was on the chair. side of the keyboard -- too much
turkey, I fear. It just happened to be easier to trigger with the patch's
double event on deletion.

I'd still love to see ENOSYS when inotify can't handle a given virtual
file.

I'm not sure "signed-off-by" if appropriate for me, but at least...

Acked-by: Morten Welinder <mwelinder@gmail.com>

Morten
