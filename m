Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYHOKKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYHOKKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYHOKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:10:15 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1957 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYHOKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:10:14 -0400
Message-ID: <8676.82.95.100.23.1218795012.squirrel@webmail.xs4all.nl>
Date: Fri, 15 Aug 2008 12:10:12 +0200 (CEST)
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to	alinuxinterfaceforon 
     access scanning
From: "Rob Meijer" <capibara@xs4all.nl>
To: david@lang.hm
Cc: "Eric Paris" <eparis@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Rik van Riel" <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>,
       "Arjan van de Ven" <arjan@infradead.org>
Reply-To: rmeijer@xs4all.nl
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, August 15, 2008 07:38, david@lang.hm wrote:
> On Thu, 14 Aug 2008, david@lang.hm wrote:
>
>> On Thu, 14 Aug 2008, david@lang.hm wrote:
>>
>>> again, libmalware.so is not referring to any specific body of code,
>>> it's
>>> referring to the concept that the handling of open/mmap/read/etc and
>>> scanning is done via a userspace library rather then by the kernel. if
>>> everyone can agree on that concept then hashing out the details of
>>> _which_
>>> library it gets put in is a smaller detail.
>>
>> one reason to layer scanners is that you could have one that just checks
>> to
>> see if the file was deployed from a OS package, if it was (and still has
>> the
>> same hash as the package manager thinks it should have) it sets a flag
>> that
>> other scanners could look for (if they see it they can skip scanning the
>> file)
>
> actually, instead of trying to have one scanner trust the results of
> another, a better approach would be for libmalware to look for the package
> manager approval and if it finds that it could skip asking the other
> scanners to look at it.

The package manager approach is interesting in that it marks 'trusted',
and is thus permissive rather than restrictive. Maybe it would be possible
to extend on this and simply define a set of currently unprivileged access
as privileged for untrusted applications. That way you could allow
untrusted software to run without risk, even if that untrusted software
turns out to be malware. That is, it may be possible to solve the malware
problem in a much more fundamental way here by just allowing malware to
run without the need to know if it is malware, just by running untrusted
software with reduced privileges.

Rob


