Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYHRBp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYHRBp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYHRBpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:45:15 -0400
Received: from mail.lang.hm ([64.81.33.126]:47189 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYHRBpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:45:14 -0400
Date: Sun, 17 Aug 2008 18:44:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Peter Dolding <oiaohm@gmail.com>
cc: davecb@sun.com, rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-Reply-To: <e7d8f83e0808171833j3aeda564j43ea4262ec2cea57@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808171839380.12859@asgard.lang.hm>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>  <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>  <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>  <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com> 
 <48A89551.9050107@sun.com> <e7d8f83e0808171833j3aeda564j43ea4262ec2cea57@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Peter Dolding wrote:

> On Mon, Aug 18, 2008 at 7:17 AM, David Collier-Brown <davecb@sun.com> wrote:
>> Peter Dolding wrote:
>>>
>>> Currently if we have a unknown infection on a  windows partition that
>>> is been shared by linux the scanner on Linux cannot see that the
>>> windows permissions has been screwed with.   OS with badly damaged
>>> permissions is a sign of 1 of three things.  ...
>>
>> It's more likely that the files will reside on Linux/Unix under
>> Samba, and so the permissions that Samba implements will be the ones
>> that the virus is trying to mess up.  These are implemented in
>> terms of the usual permission bits, plus extended attributes/ACLs.
>> Linux systems mounting Windows filesystems are somewhat unusual (;-))
>>
> More desktop use of Linux more cases of ntfs and fat mounted under
> Linux.  Funny enough linux mounting windows file systems is 100
> percent normal for most Ubuntu users so there are a lot of them out
> there doing it.   I am future looking there are other filesystems
> coming with there own issues as well.

but what you are missing is that when they are mounted under linux it 
doesn't matter what hidden things the other OS may access, all that 
matters is what Linux sees. If Linux doesn't see something it can't serve 
it out to those other OSs.

those 'hidden things' would only matter if you were trying to use linux 
to scan a drive and bless it for another system to then mount locally. If 
we aren't trying to defend against that (and I don't hear anyone other 
then you saying we should) then we don't need to worry about such things.

If we were trying to make the drive safe for all other OSs to mount 
directly, then mearly seeing everything isn't enough, you would have to be 
able to fully duplicate how the other OS interprets the things you are 
seeing, and know all vunerabilities that arise from all possible 
interpretations. I don't think that's possible (and I don't think it would 
be possible even if the source for all those other OSs were available)

David Lang
