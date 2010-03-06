Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0CFQar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 11:30:47 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:60563 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0CFQap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 11:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bxpU6yZL64VewaRPq12aUn8iqih+lA1D8oHyIok9SE0WmwLC7g7q5pf2hzTQ5S2uUv
         eWTn8VA5Aajzb7Y7jrrDjq9wfGOHIyVw1t6fbpf0u9mibsINUgrwfCe3tIVNhc7tleOy
         Xqbwk94dg89MIDfOhhEKMmCfTGFSTI60yUWoo=
MIME-Version: 1.0
In-Reply-To: <20100303000938.GA3257@kroah.com>
References: <20100227051737.GA14976@kroah.com>
	 <Pine.LNX.4.44L0.1002271215290.25155-100000@netrider.rowland.org>
	 <20100303000938.GA3257@kroah.com>
Date: Sat, 6 Mar 2010 17:30:44 +0100
Message-ID: <d9def9db1003060830i52e4c1c5k824e5d8318d9a67c@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, werner@guyane.dyn-o-saur.com,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 1:09 AM, Greg KH <greg@kroah.com> wrote:
> On Sat, Feb 27, 2010 at 12:20:35PM -0500, Alan Stern wrote:
>> On Fri, 26 Feb 2010, Greg KH wrote:
>>
>> > Hm, so it's back to the original idea of just doing a kzalloc of the
>> > initial buffer, that should solve the problem that Marcus found.
>> >
>> > I'll go dig that back up and if you could test it, that would be most
>> > appreciated.
>>
>> Here's a better solution.  In theory we could copy just the individual
>> packets from within the transfer buffer, but that would probably take
>> longer than simply copying the whole buffer.
>>
>> (This was a little hasty; I haven't even compile-tested the patch.
>> Some small fixes may be needed.)
>
> Markus, did you test this patch out?
>

works properly with ISO, (bulk is not tested from my side). please
merge asap this also affects scanners (SANE).

Markus
