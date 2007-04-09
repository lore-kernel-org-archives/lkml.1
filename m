Return-Path: <linux-kernel-owner+w=401wt.eu-S965818AbXDIPpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818AbXDIPpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965826AbXDIPpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:45:52 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:32971 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965818AbXDIPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JjBvx3ZegNsrCNWN/LE/hNjOqIanaR3iYqA8TPJ2Rv4rbKGpoQBBmKudQQvYIA7Fcs+vOXmOe9omBg+wyvJa7F9lAvrQvM4+SbvUe90vVZEvi0dip4uy4n7DEG98+oHeIRUgZgv+qQFmvmYCv2vsC7WQADlEmxNiwpJ/ba8obck=
Message-ID: <7b69d1470704090845v2102113fv235c3c09dbadbd51@mail.gmail.com>
Date: Mon, 9 Apr 2007 10:45:49 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: coding style for long conditions
Cc: "David Brownell" <david-b@pacbell.net>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Tony Lindgren" <tony@atomide.com>, linux-kernel@vger.kernel.org
In-Reply-To: <adabqi16v5a.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11757099691323-git-send-email-tony@atomide.com>
	 <200704061029.55710.david-b@pacbell.net>
	 <46169968.2050006@s5r6.in-berlin.de>
	 <200704061405.50169.david-b@pacbell.net> <adabqi16v5a.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/07, Roland Dreier <rdreier@cisco.com> wrote:
> [I can't believe I'm stepping into an indentation flamewar, but here goes...]

> that the line with "bar" on it is properly indented with one tab
> (since it is part of the if statement that is also indented one tab),
> and then four spaces are used to align the "bar" with the previous
> line.  So only tabs are used for indentation, and the spaces after the
> tab are used for alignment, and the letter of the law is observed.
>
> If you have a git tree handy, you can do "git show 68380b58" and see
> that Linus himself wrote:
>
>         if (get_wq_data(work) == cwq
>             && work_pending(work)
>             && !list_empty(&work->entry)) {
>
---

I'm happy to see Linus did it exactly the way I would have...

So, perhaps the rule in CodingStyle should be clarified to say that
indentation is used to show nesting depth and always expressed in TAB
characters, but additional spacing may be used following the
structural TABs to appropriately format continuation lines...

scott
