Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbXK2Pqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbXK2Pqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXK2PqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:46:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:42157 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXK2PqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=u06PwBc2uksN61sJg0MhAXeHg7xNsUonRfzGxOoK6yt269FD5yvw02XjsSGqnYaCllpdp9ugS0D+rhR4vGnmf2ekXah3dYkeOsTNlbccc7SMIidocyLkaxu7u+bOgBHdYWgJFwjCN4QS/JJ2LbuGfxrLv5LX+6TIYdlG8Iqauh0=
Message-ID: <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com>
Date: Thu, 29 Nov 2007 07:46:19 -0800
From: "Dan Kegel" <dank@kegel.com>
To: "Xavier Bestel" <xavier.bestel@free.fr>
Subject: Re: Relax permissions for reading hard drive serial number?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1196350632.20567.191.camel@skunk.anacadf.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com>
	 <1196350632.20567.191.camel@skunk.anacadf.mentorg.com>
X-Google-Sender-Auth: cf440fa1f45b58c4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 7:37 AM, Xavier Bestel <xavier.bestel@free.fr> wrote:
> > One sticking point is that apps like Photoshop and probably
> > Punkbuster want to retrieve the hard drive's serial number
>
> So they can't be installed on a network drive ?

I think Adobe supports that, though perhaps not with the
retail version.  Big companies with network drives are
probably an important revenue source for them.

I haven't looked closely at what happens when you try installing
onto network drives.  If you are really interested, it's pretty easy to
try yourself; just run the app under wine with
WINEDEBUG=+cdrom,+disk and look in the log for calls like
CreateFile("\\\\.\\PhysicalDrive0", ...).
There's some chance the code always checks drive 0 instead
of the drive you're installing onto.
- Dan
