Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZD2Szw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZD2Szw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZD2Szj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:55:39 -0400
Received: from blaine.gmane.org ([80.91.229.8]:41249 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbZD2Szh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OHE1H3EkD6RRFEkBHsxHtRbv3zDvcEdIAValCQRUPJKTrkje1Is7TTDkuZW39PWuz/
         WhdPugN7YmKdZLyDlkEtwPuNujnSEx94KKLhcmZsJAD/dHwHi+cfACwvwAwyDnS75vaZ
         J39twiHxPJo9wmR0ksRmRMeF2YBBJ+8frB4Vw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0904291150200.24643-100000@netrider.rowland.org>
References: <m3ab5z35f1.fsf@ursa.amorsen.dk>
	 <Pine.LNX.4.44L0.0904291150200.24643-100000@netrider.rowland.org>
Date: Wed, 29 Apr 2009 13:27:36 -0400
Message-ID: <8bd0f97a0904291027y56dd65d4ha77b636036f567c@mail.gmail.com>
Subject: Re: usbutils 0.81 release
From: Mike Frysinger <vapier.adi@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Benny Amorsen <benny+usenet@amorsen.dk>,
       Alan Stern 
	<public-stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@hugh.gmane.org>,
       Greg KH <public-greg-U8xfFu+wG4EAvxtiuMwx3w@hugh.gmane.org>,
       Kay Sievers <public-kay.sievers-tD+1rO4QERM@hugh.gmane.org>,
       USB list <public-linux-usb-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Kernel development list 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TMDA-Confirmed: Wed, 29 Apr 2009 20:30:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, Apr 29, 2009 at 11:51, Alan Stern wrote:
> On Wed, 29 Apr 2009, Benny Amorsen wrote:
>> Alan Stern writes:
>> > Sure they do.  If you've got an RPM-based system, and you want to
>> > install a package version that's more recent than the one bundled in
>> > your distribution (or if your distribution doesn't include the package
>> > at all), then you'd want to build your own RPM.
>>
>> In that case you grab the source package from the distribution, install
>> it, bump the version number and add the tar file to the SOURCES
>> directory. (And then you remove the patches which were upstreamed in the
>> meantime).
>
> You didn't read all that I wrote.  What if the package isn't included
> in the distribution at all?

install a different distro.  any distro even remotely worth its salt
is going to package usbutils.  this is a devils advocate question, not
anything resembling reality.

otherwise, anyone who is going to build a rpm should be familiar with
the myriad of possibilities out there that handle exactly this case
(such as checkinstall).
-mike


