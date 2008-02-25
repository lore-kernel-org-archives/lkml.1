Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbYBYUpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbYBYUpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbYBYUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:45:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:1640 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759258AbYBYUpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QZx1LHR79j0Bdm11RlmKmLmbWGBEd358xDz9StfuqyYYPg/nItPo4jzDJN97lshireVklqpjHAroZ7ruAfFmMz62kqzbJbCWNdC2JRigbO00WukeEHKLUYMUU7n0kfW4prYIk2Q3LnWZZItZdwvRJj9Hqj/5KYQkzhzBASMK1VI=
Message-ID: <8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com>
Date: Mon, 25 Feb 2008 22:45:02 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org
In-Reply-To: <20080225114611.d91791f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
	 <20080225114611.d91791f6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 9:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 25 Feb 2008 21:19:24 +0200 "Michael S. Tsirkin" <m.s.tsirkin@gmail.com> wrote:
>
>  > On my T61p, 2.6.25-rc2 seems to get acpi events from keypresses
>  > such as Fn-F4 and lid open/close, prints them in /var/log/acpid
>  > and reacts accordingly (my acpi scripts suspend on lid close and Fn-F4).
>
>  You mean suspend-to-ram works correctly on your t61p?
>
>  Mine suspends, then five seconds later magically resumes itself and the
>  screen is all black.

Sorry, have not noticed what you were asking about.
Yes, rc2 seems to suspend/resume fine.

And after reverting

     revert commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.
     revert commit 208c70a45624400fafd7511b96bc426bf01f8f5e.

r3 does, too.
I just waited a couple of minutes after suspend to ram and it stays suspended.
