Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYHRBRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYHRBRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYHRBRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:17:24 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:46026 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYHRBRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:17:23 -0400
Date: Sun, 17 Aug 2008 17:17:05 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-reply-to: <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
To: Peter Dolding <oiaohm@gmail.com>
Cc: david@lang.hm, rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>,
       Arjan van de Ven <arjan@infradead.org>
Reply-to: davecb@sun.com
Message-id: <48A89551.9050107@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
 <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
 <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
 <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Dolding wrote:
> Currently if we have a unknown infection on a  windows partition that
> is been shared by linux the scanner on Linux cannot see that the
> windows permissions has been screwed with.   OS with badly damaged
> permissions is a sign of 1 of three things.  ...

It's more likely that the files will reside on Linux/Unix under
Samba, and so the permissions that Samba implements will be the ones
that the virus is trying to mess up.  These are implemented in
terms of the usual permission bits, plus extended attributes/ACLs.
Linux systems mounting Windows filesystems are somewhat unusual (;-))

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
