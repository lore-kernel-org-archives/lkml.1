Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYEZR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYEZR2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYEZR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:28:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:10247 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYEZR20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sgXlDSH6XQ/W1jEpUs+msu5AvCCn33ohfht/ySbfxzDQdodAH3lKJ6XYG12kgjq5rVvwYljcFCI7XqF5TK4GEU/b3jrQ8P4N2L6QKIwwzH5UgIHvmtXock1i9inPFq6P6Zu0IkiZYIz3i+jAFghQ9kjABeVAIgXZ/ZNzLqSPxyE=
Message-ID: <e2e108260805261028o204d4fc7l3f20ad3919cf778b@mail.gmail.com>
Date: Mon, 26 May 2008 19:28:23 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Cc: "Theodore Tso" <tytso@mit.edu>, "Ingo Molnar" <mingo@elte.hu>,
       "Jan Kara" <jack@suse.cz>, "Arjan van de Ven" <arjan@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200805261909.59032.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4836EE8C.1010200@linux.intel.com> <20080526164858.GA24098@elte.hu>
	 <20080526170147.GB9893@mit.edu> <200805261909.59032.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 7:09 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag 26 Mai 2008 19:01:48 schrieb Theodore Tso:
>> If the USB stack folks would like to work on how to recognize that
>> it's the same USB stick that had been previously pulled, so that it
>> gets the same block device, and we can decide for how long we should
>> keep dirty buffers around associated with a pulled USB stick, we can
>> certainly have that conversation.  :-)
>
> Even if we could tell whether the device has remained the same, how
> would we know the medium wasn't exchanged?

Looking at the filesystem UUID could help -- this is an ID that is
present as data on the disk, and that is even independent of the bus
type. See also /dev/disk/by-uuid.

For the journaling filesystems I am familiar with the default value
for the commit parameter is 5 seconds. Would it be a good idea to
leave the default to 5s for non-removable devices, and to change this
default to 1s for removable devices ?

Bart.
