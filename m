Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXAaSzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXAaSzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXAaSzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:55:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:25848 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbXAaSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A05m2Ze+IR07X9Mi0q3vOz1loedsy64dUCnUYfnB3i24bCeknsov4RZGwfXNjdOGNzq32kl3h5+UIE973dP4pN2rkwoFa6lrkZdJQcfMuXUjz7bh4Zm529DoAt69WE9Cux5w4KU93AWvoO+CbijSEwiIZjR5+uaCPrwW8gpgf0M=
Message-ID: <d66e87630701311055h49a03552m904cbf00751dd805@mail.gmail.com>
Date: Wed, 31 Jan 2007 13:55:15 -0500
From: "Eddie Pettis" <pettis.eddie@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: How to locate struct file * from a bio?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45C0B343.1090301@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d66e87630701310634s385db5adwa82e2194188efa81@mail.gmail.com>
	 <45C0B343.1090301@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> Eddie Pettis wrote:
> > Short question:  Is it possible to locate the struct file * associated
> > with a bio?  If so, how?
> >
>
> Looks like you do this the wrong way.

Agreed.  It was a bad hack based on something I had done previously.

>
> Why don't you tap into "open" instead?
> Here you can note who opens the file and if they open it for
> reading or writing.  If you really need the amount of data
> transferred, consider trapping the read and write syscalls too.

I added hooks to the sys_* system calls for read/write/open/close from
userspace, and that seems to work.

Thanks!

>
> Helge Hafting
>
