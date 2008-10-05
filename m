Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbYJEXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbYJEXS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 19:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYJEXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 19:18:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:63962 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbYJEXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 19:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sdH+TJo47DILs/XdleuusHLvDHQZlP0lptbASrSXjoA2fx7Mxs6pqGeIhD6DJY8nJ/
         5mjmzHZWcubDPm9cmhB9rbv+QuKaCHRrKBToD8KTYouhO9A8ErU3QIV7pxJw+CP/TYAR
         cJ6gKM3mGdelJp+ND3Cz4Inz2Y1/j+yO8q/cY=
Date: Mon, 6 Oct 2008 03:20:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] proc: show personality via /proc/pid/personality
Message-ID: <20081005232053.GA19199@x200.localdomain>
References: <20081002211424.GJ10632@outflux.net> <20081004145149.52c34ee7@infradead.org> <20081004220220.GK10632@outflux.net> <20081004164239.0c1483a4@infradead.org> <20081005004233.GL10632@outflux.net> <20081004174843.6fe48a8e@infradead.org> <20081005091120.GA21003@x200.localdomain> <20081005101438.GR10632@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005101438.GR10632@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 03:14:38AM -0700, Kees Cook wrote:
> Make process personality flags visible in /proc.  Since a process's
> personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
> file only readable by the process owner.

Applied to proc.git, and I moved show hook to fs/proc/base.c where most
of this irregular stuff lives.

> Please revert the prior patch against the "status" file -- this is the
> alternative.

Sure.
