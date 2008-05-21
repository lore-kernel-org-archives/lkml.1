Return-Path: <linux-kernel-owner+w=401wt.eu-S934767AbYEUNqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767AbYEUNqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbYEUNqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:46:24 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:17554 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762905AbYEUNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IgXimkwuPxIZKNt9m4oG8iMbmzO5f1Pnvjct4u8HBUTPoTtEx474pbiebyNxgfCMmbVHRUyukuLYIbKThFHUToE7mKj7FxuOkl192bdLVm3nPfD27s/SviTNcNebIGg6xTXh2G4XepWnNwp35BxOSB2vSxydHiGzOHpu/dr1rPY=
Message-ID: <84144f020805210646w5eeaef22r2c3e88afa366f42b@mail.gmail.com>
Date: Wed, 21 May 2008 16:46:22 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: Tracking and crediting bug reporters
Cc: "Pavel Machek" <pavel@ucw.cz>, "Jonathan Corbet" <corbet@lwn.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87r6bv4w7o.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4388.1210613272@vena.lwn.net> <20080521104145.GB4948@ucw.cz>
	 <87r6bv4w7o.fsf@saeurebad.de>
X-Google-Sender-Auth: 751df69d094c399e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 4:34 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> I would more argue to remove Tested-by completely because it does not
> tell much.  Code is not bugfree just because someone compiled and ran
> it.  And if it breaks on some other systems later on, what does it help
> if you know someone tested it?  It still breaks.  And you can not even
> blame the tester because of his luck of a working configuration.

Tested-by is really helpful for identifying potential testers when you
change some part of the kernel. I use git history to identify people
who are able/willing to test NUMA changes to the slab allocators that
require a big ass NUMA box to trigger a bug, for example. Also, in
some cases, testing a bug fix is not trivial and might require a lot
of work that we should give credit for.
