Return-Path: <linux-kernel-owner+w=401wt.eu-S1751369AbYHRBeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbYHRBeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYHRBdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:33:54 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:44694 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYHRBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DJUgRKtdBU4H9GraTCUieDH5DtJNib0dFBsE6z7OmN2FKJc6NvIx9DMT8oFBCze2qO
         YKQHSqtA3ZCjgT/KFMq3QBGWS9CjOJilFNaFbgsKMPEDRI/oHOtzCjQB7btXrbQHj/Ep
         BtRJ3i2JlFrdwxasEzTq9nHQqwFbHPWLULcos=
Message-ID: <e7d8f83e0808171833j3aeda564j43ea4262ec2cea57@mail.gmail.com>
Date: Mon, 18 Aug 2008 11:33:50 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: davecb@sun.com
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Cc: david@lang.hm, rmeijer@xs4all.nl, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, "Eric Paris" <eparis@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       linux-security-module@vger.kernel.org, "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <48A89551.9050107@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
	 <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
	 <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
	 <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
	 <48A89551.9050107@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 7:17 AM, David Collier-Brown <davecb@sun.com> wrote:
> Peter Dolding wrote:
>>
>> Currently if we have a unknown infection on a  windows partition that
>> is been shared by linux the scanner on Linux cannot see that the
>> windows permissions has been screwed with.   OS with badly damaged
>> permissions is a sign of 1 of three things.  ...
>
> It's more likely that the files will reside on Linux/Unix under
> Samba, and so the permissions that Samba implements will be the ones
> that the virus is trying to mess up.  These are implemented in
> terms of the usual permission bits, plus extended attributes/ACLs.
> Linux systems mounting Windows filesystems are somewhat unusual (;-))
>
More desktop use of Linux more cases of ntfs and fat mounted under
Linux.  Funny enough linux mounting windows file systems is 100
percent normal for most Ubuntu users so there are a lot of them out
there doing it.   I am future looking there are other filesystems
coming with there own issues as well.

Same issue with samba no common store for extra permissions exist so
on file systems that don't support there permissions storage it goes
back into there tdb storage.

Basically scanning everything to detect issues currently nicely
complex.  We have a huge permissions mess.  Some permissions are
processed by the file system drivers.  Some are processed by vfs then
others processed and stored by individual applications.   So no where
in Linux can you see all the permissions being applied to a single
file to be sure there is not a secuirty risk somewhere.  Samba or
equal allowing access to remove a virus signature from the black list
or added something that should not be allowed to the white list would
be major problems.

Posix has not helped US here at all.   No where in posix does it
provide anything to clean up this mess.  Does solarias have a solution
I know BSD and Linux does not.   I think all posix OS's have a mess in
this section.

Peter Dolding
