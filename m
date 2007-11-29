Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbXK2Rjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbXK2Rjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXK2RjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:39:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:35107 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbXK2RjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AwvQVWOqAtR/B3ZAMPrxKaJ31+NvkcYx/1sLNGl6bCOH8qrtm2GKhrYR0R6clCqANeImGPVs/hrwnjS12DDa42DBeGXnJRIORT/tSSCMP4z5yIsvuyzdeXgXHzIIkEPIrDB0Cab52w0yXpWORR2+PyxYmoRVILuAHaUgaaIDF/0=
Message-ID: <3ae72650711290939w4fee581fm6f0d65a33abf1b82@mail.gmail.com>
Date: Thu, 29 Nov 2007 18:39:21 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Dan Kegel" <dank@kegel.com>
Subject: Re: Relax permissions for reading hard drive serial number?
Cc: "Xavier Bestel" <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com>
	 <1196350632.20567.191.camel@skunk.anacadf.mentorg.com>
	 <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com>
X-Google-Sender-Auth: a1d7eb92fd482327
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 4:46 PM, Dan Kegel <dank@kegel.com> wrote:
> On Nov 29, 2007 7:37 AM, Xavier Bestel <xavier.bestel@free.fr> wrote:
> > > One sticking point is that apps like Photoshop and probably
> > > Punkbuster want to retrieve the hard drive's serial number
> >
> > So they can't be installed on a network drive ?
>
> I think Adobe supports that, though perhaps not with the
> retail version.  Big companies with network drives are
> probably an important revenue source for them.
>
> I haven't looked closely at what happens when you try installing
> onto network drives.  If you are really interested, it's pretty easy to
> try yourself; just run the app under wine with
> WINEDEBUG=+cdrom,+disk and look in the log for calls like
> CreateFile("\\\\.\\PhysicalDrive0", ...).
> There's some chance the code always checks drive 0 instead
> of the drive you're installing onto.

There are people who, for privacy reasons, really don't like that "unique"
unchangeable serial numbers can be retrieved by untrusted users.

You should probably chmod the file on the users system, if he is fine with
that, but not change the kernel default.

Kay
