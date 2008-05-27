Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYE0GMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYE0GMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYE0GMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:12:41 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38793 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYE0GMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:12:40 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Date: Tue, 27 May 2008 08:12:37 +0200
User-Agent: KMail/1.9.9
Cc: "Theodore Tso" <tytso@mit.edu>, "Ingo Molnar" <mingo@elte.hu>,
       "Jan Kara" <jack@suse.cz>, "Arjan van de Ven" <arjan@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>
References: <4836EE8C.1010200@linux.intel.com> <200805261909.59032.oliver@neukum.org> <e2e108260805261028o204d4fc7l3f20ad3919cf778b@mail.gmail.com>
In-Reply-To: <e2e108260805261028o204d4fc7l3f20ad3919cf778b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805270812.38797.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 26 Mai 2008 19:28:23 schrieb Bart Van Assche:
> > Even if we could tell whether the device has remained the same, how
> > would we know the medium wasn't exchanged?
> 
> Looking at the filesystem UUID could help -- this is an ID that is
> present as data on the disk, and that is even independent of the bus
> type. See also /dev/disk/by-uuid.

The medium may or may not hold a filesystem that has a UUID.
In addition you can clone filesystems with dd but reuse them as
independent filesystems.

Yes, you could checksum parts of the filesystem and say that at some
point the user should suffer the consequences of his stupidity, but
such things don't belong into the kernel and neither are they specific
to USB.

	Regards
		Oliver

