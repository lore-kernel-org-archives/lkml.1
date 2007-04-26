Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbXDZIXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbXDZIXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbXDZIXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:23:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:16779 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602AbXDZIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GvIOQekLSAjqj6nr3hD7raIdBnb8OhpSjqjt+poa6yJGrJRbpqO65sLWGYQIN1MrwgQvyFLyOwq/HEIMg9i+fL6IWHxPzLAZOTtwXVe4aBvA14CahTLpbkX4x2LXUarDOlGwvkQ51zKqCOURgYIF5NOyWyo3Foqaemybvj6ZbFk=
Message-ID: <84144f020704260117l3794ebe3q7aaa49bc98888d01@mail.gmail.com>
Date: Thu, 26 Apr 2007 11:17:17 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: nigel@nigel.suspend2.net
Subject: Re: Back to the future.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1177573348.5025.224.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
X-Google-Sender-Auth: 2823bad3edcf6330
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nigel,

On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> * Doing things in the right order? (Prepare the image, then do the
> atomic copy, then save).

As I am a total newbie to the power management code, I am unable to
spot the conceptual difference in uswsusp suspend.c:suspend_system()
and suspend2 kernel/power/suspend.c:suspend_main(). How are they
different?

On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> * Mulithreaded I/O (might as well use multiple cores to compress the
> image, now that we're hotplugging later).

I assume this doesn't affect the kernel at all with uswsusp?

On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> * Modular design?

This is too broad. Please be more specific of the problems the current
suspend and snapshot/shutdown code in the kernel has.

Now to add to your list, as far as I can tell, suspend2 provides
better feedback to the user via the netlink mechanism (although the
kernel shouldn't be sending messages such as userui_redraw but instead
let the userspace know of the actual events, for example, that tasks
have now been frozen). However, I am unsure if this is still relevant
as most of the work (snapshot writing) is being done in userspace
where we explicitly know when processes have been frozen, when the
snapshot is finished, and when it's written to disk.

                                              Pekka
