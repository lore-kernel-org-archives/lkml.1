Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYHOMaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYHOMaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYHOMaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:30:10 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2598 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYHOMaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:30:08 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 08:30:08 EDT
Message-ID: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
Date: Fri, 15 Aug 2008 14:22:17 +0200 (CEST)
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to	alinuxinterfaceforon 
          access scanning
From: "Rob Meijer" <capibara@xs4all.nl>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: rmeijer@xs4all.nl, capibara@xs4all.nl, david@lang.hm,
       "Eric Paris" <eparis@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
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

On Fri, August 15, 2008 13:02, Alan Cox wrote:
>> The package manager approach is interesting in that it marks 'trusted',
>> and is thus permissive rather than restrictive. Maybe it would be
>> possible
>> to extend on this and simply define a set of currently unprivileged
>> access
>> as privileged for untrusted applications. That way you could allow
>> untrusted software to run without risk, even if that untrusted software
>> turns out to be malware. That is, it may be possible to solve the
>> malware
>> problem in a much more fundamental way here by just allowing malware to
>> run without the need to know if it is malware, just by running untrusted
>> software with reduced privileges.
>>
>
> Its called SELinux and SELinux can already do this sort of stuff,
> including things like "only rpm may create files you are permitted to
> execute"

This "permitted to execute" is what I feel is the wrong aproach with
respect to malware. If you simply allow everything to 'execute', I think
that untrusted programs may still be used for usefull things, but without
the potential do do malice. If you start from the point where everything
both trusted and untrusted  is permitted to be executed, you could make it
the job of SELinux or any other LSM to make untrusted code run without
doing malice, but with the possibility to still run and do usefull non
malicious  stuff. This might require some aditional hooks in LSM though I
could imagine.

To take this one step further, it might be usefull to see what kernel/LSM
changes would be needed to allow SELinux and/or possibly better yet,
AppArmor, to work with some powerbox style UI component in order to both
allow and force untrusted programs to run with least authority and still
do usefull stuff.

I feel the Polaris/Capdesk/Plash approach to untrusted code is much more
prommising than the "don't run" approach used by regular AV products.
Making such an approach integrate with LSM's would IMHO be a much more
fundamental approach to malware.

Rob

