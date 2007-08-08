Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbXHHOAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbXHHOAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXHHOA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:00:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:50959 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbXHHOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fGSf1hHr1s3hx6OoDjOPWE7rIWiVOfSybTBmIBbRaj45A7EZ769HyVCqAYEx6a1lsXOhwj9NYiekzx3PygOxP+wkN5JmKqWEP4v4Et59nPx6R8NOaciAFl4ImdY+duCkllbkrTREs/t9KcWwtOVeccKakrYgnzaItQPQjMTIzpQ=
Message-ID: <5d6222a80708080700t26e602c8ga88753e041268727@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:00:25 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Cc: "Andi Kleen" <ak@suse.de>, "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
In-Reply-To: <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <1186546820708-git-send-email-gcosta@redhat.com>
	 <11865468243612-git-send-email-gcosta@redhat.com>
	 <200708081138.23018.ak@suse.de>
	 <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > ENTRY adds alignment. Why do you need that export anyways?
>
> The paravirt ops struct points to it.

But the paravirt_ops probably won't need it as an export. So I guess
andi is right.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
