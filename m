Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbXCYFfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbXCYFfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXCYFfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:35:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:10398 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbXCYFfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UviZF2DalJssklvXlluBOts0vkiBxzcyhI/0hv4MyTousHrx7hJbzXd0iGf4Wv9JQb/Mv0ydeS+QmoldQkPKMgsIqwJxicfkvEgNFO+HstQcDT2Q9AzNFNPXJ3gB1DF7nRCvI0wkBM6iDYrNGpaoPZmTYlsYLHAoQVfuzjJmDpE=
Message-ID: <82e4877d0703242235r7c83a867hd4f3ec740e8627fb@mail.gmail.com>
Date: Sun, 25 Mar 2007 01:35:35 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: keyboard.c: Stop flooding dmesg with useless warnings
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>
In-Reply-To: <200703250129.32877.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703242315160.492@paragw-desktop>
	 <200703250115.02029.dtor@insightbb.com>
	 <82e4877d0703242227q7961833aie851e14764002264@mail.gmail.com>
	 <200703250129.32877.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> On Sunday 25 March 2007 01:27, Parag Warudkar wrote:
> > >
> > > Actually the keyboard driver should not emit input events for that key code.
> > > Is this a USB keyboard?
> > >
> > > --
> > > Dmitry
> > >
> >
> > Yes this is a USB keyboard.
> >
> > Any hint as to where I should start looking to make the driver not
> > emit input event for keycode==0?
> >
>
> Was it always doing that? I'll add Jiri Kosina to the CC list as he's
> involved with HID now.
>

Something (some keypress?) triggers it (by default it doesn't happen
immediately after a boot) - but once it starts it doesn't seem to stop
printing.

Parag
