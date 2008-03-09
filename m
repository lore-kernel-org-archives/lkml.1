Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYCIK1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYCIK1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYCIK0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:26:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:51963 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYCIK0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ADAVg0UOLjow8m0AogAfjM/QfVanat91PeMsqywjzq73msFwebMorz/NtNpgJDvoTGMnrXclVCsOsXQfO3zhJVx+IBnVYLuNJmWgW8MpF/MK78cyg3LEp5zhHd++pH9htwoE2HWPAan+8/bfQ0ZXZy+85dkZIYpY5sPlgvCP9Dk=
Message-ID: <e2e108260803090326j5e418c7dq41c72ef09f6991e@mail.gmail.com>
Date: Sun, 9 Mar 2008 11:26:51 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: quicklists confuse meminfo
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2008 at 11:19 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Bart reported http://bugzilla.kernel.org/show_bug.cgi?id=9991.
...
>  +               "QuickLists:   %8lu kB\n"

Regarding the patch: maybe it's better to spell this entry
"Quicklists" than "QuickLists", since quicklist is a single word and
not two words ?

Regarding the memory occupied by quicklists: why does the amount of
memory occupied by quicklists increase over time ? Is there a way to
free the memory occupied by quicklists, similar to the way the memory
occupied by caches can be freed (echo 3 >/proc/sys/vm/drop_caches) ?

Bart.
