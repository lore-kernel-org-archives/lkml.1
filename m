Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab0BNOt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:49:26 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60390 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0BNOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=vossXf9lRHsGMo+Y8QJeS+UchNhW5njkC17UU8iXxJCVYgbZQ0V42jxyWLk+U/chJc
         BnUz5ZyE6N7DgyapZlwy9/4lFHsrNC6iTg4IB5OBSDKbRxpa9tFJErGuIou+mG5Zpwos
         pbtvNKiUtATx9VwpbFWlfbRN5FgcAVkBEAo/Y=
From: Harald Arnesen <harald@skogtun.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
       lasse.collin@tukaani.org, mirrors@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<4B75A5FE.8020408@zytor.com> <20100212202534.GH11239@parisc-linux.org>
Date: Sun, 14 Feb 2010 15:49:20 +0100
In-Reply-To: <20100212202534.GH11239@parisc-linux.org> (Matthew Wilcox's
	message of "Fri, 12 Feb 2010 13:25:34 -0700")
Message-ID: <87k4ufeutr.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> On Fri, Feb 12, 2010 at 11:03:26AM -0800, H. Peter Anvin wrote:
>> > 3* Create a new subdirectory for every 2.6.x kernel, and move all the
>> > related files there. This would shrink the main index drastically, and
>> > each subdirectory would have a reasonable size (except maybe 2.6.16 and
>> > 2.6.27.) Oddly enough this has been done for the files under testing/
>> > already, so I am curious why we don't do it for the release files (and
>> > the testing/incr/ files, while we're at it.)
>> 
>> Well, part of the reason why is that we're functionally "stuck" on 2.6;
>> a prefix which really has lost all meaning.
>> 
>> It might open up the question if we shouldn't just do a Solaris and drop
>> the leading 2 (so the next kernel would be 6.33) or call the kernel
>> after that 3.0 instead of 2.6.34, and then 3.1 instead of 2.6.35.
>
> Damn, we forgot to have that fight at Kernel Summit last year.
>
> I'm in favour of the 3.0 / 3.1 / 3.2 with stable@ being responsible for
> 3.0.1, 3.0.2, 3.1.1, etc.

Like I suggested in October 2008, but it would have been more natural at
that time:

<http://marc.info/?l=linux-kernel&m=122418454113793&w=2>
-- 
Hilsen Harald.
