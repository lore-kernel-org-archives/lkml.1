Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZIUC7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZIUC7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 22:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZIUC7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 22:59:48 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:36435 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbZIUC7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 22:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N3FOzHqWDlRJ86QXS+1gzdRvqLfEus4Pg+lj2q4vgtDUdyyunKDZu7WJcu1IoXY3M0
         v06gLY7fw7ExxwC/k/7f+wgsLr4NYqE8+uDXDa/F7QjDSD+px1cibwrjUR5JcdiUWlBu
         YZpxi0wLRvQOPyk0bWgGvOMrKuEzOdcVC8puk=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510909200914g1ed6a47cydc0edec6fff96ef4@mail.gmail.com>
References: <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
	 <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>
	 <20090918150541.GB9307@kroah.com>
	 <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com>
	 <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
	 <20090918195005.GA11726@elte.hu>
	 <21d7e9970909191843l6fbb835bme509c18cedfd728c@mail.gmail.com>
	 <20090920150842.GF11621@kroah.com>
	 <ac3eb2510909200912o76e0d4e4l2dcaf352fe6b4e19@mail.gmail.com>
	 <ac3eb2510909200914g1ed6a47cydc0edec6fff96ef4@mail.gmail.com>
Date: Mon, 21 Sep 2009 12:59:50 +1000
Message-ID: <21d7e9970909201959j1268103fg9d88625072e089a@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was: 
	Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster)
From: Dave Airlie <airlied@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 2:14 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> Distros ship these matches for forever. It's a modprobe.conf blacklist entry
> that's needed, or better disable thew floppy in the BIOS, if there isn't one
> to use.
>

The patch only went into the kernel last release or maybe one before,
and it came from Ubuntu's
kernel, we instantly got a lot of people giving out about udev getting
slow, where we get very
few reports from people about not having their floppy accessible.

Disabling the PNP ids was the lesser of two evils, since floppys
really aren't that common, but BIOSes with floppy drives enabled are.

Dave.
