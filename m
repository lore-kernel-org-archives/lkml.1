Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbXE3O1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbXE3O1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXE3O1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:27:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:43883 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXE3O1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LRb1eZE3zV+DnrncER8jsXAaT5mwXCufsxTV7G7fgppPQr7EmQkKF//AOM3eWXQVtMwRx2/eRYYMdreizsvT78J7SjthE0zqHteZyNrRMR2h3+Z7m4w/8NakZC7R4RlxUOXLGwui/tfcsmX3iXgMm7tCIKFutcM9QfGpeqPaUJE=
Message-ID: <d120d5000705300727g7ddfb845sa02ad92a434aefc6@mail.gmail.com>
Date: Wed, 30 May 2007 10:27:03 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [PATCH] Input: i8042 - cleanup of debug code (was Re: 2.6.22-rc2-mm1)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705301603200.10318@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <1179962229.8575.4.camel@localhost>
	 <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
	 <200705232328.42657.dtor@insightbb.com>
	 <Pine.LNX.4.64.0705301603200.10318@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 5/30/07, Jiri Kosina <jikos@jikos.cz> wrote:
>
> From: Jiri Kosina <jkosina@suse.cz>
>
> Input: i8042 - cleanup of debug code
>
> Debugging facility of i8042 is now toggled in runtime instead
> of needing to recompile the kernel. Therefore the DEBUG macro
> is useless (it's hardcoded to be defined anyway). Remove it.
>

I'd rather leave it as is in case someone wants to squeeze last bit of
memory savings from the kernel. Also there some security issues
(someone breaking into the box and enabling i8042 debug and capturing
all keycodes) so uber-sensitive folks can use it to disable debug
completely.

-- 
Dmitry
