Return-Path: <linux-kernel-owner+w=401wt.eu-S1765412AbYHDW1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765412AbYHDW1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764881AbYHDW11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:27:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:62292 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764897AbYHDW10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SHOWR7MFNgGjfjGiR0HE2yE27ZG8M1pMZESQY15vILMJohvu8fDmtjmejrN15KUOud
         AM0tQzIKukePTQ09izEg7xtfZjvUITzTHc9kTz+nod/0qpJyoDviVO+bZ8OEqLbwlmaP
         5CB/TlCb+dHGJbYgWa1yP8RU6aAdvuAWdIaog=
Message-ID: <21d7e9970808041520k64506cf0k14e4f8e3d5a316bd@mail.gmail.com>
Date: Tue, 5 Aug 2008 08:20:32 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Ingo Oeser" <ioe-lkml@rameria.de>
Subject: Re: files/process scaling problem? (was: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM)
Cc: "Keith Packard" <keithp@keithp.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "John Stoffel" <john@stoffel.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Anholt" <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200808042346.51391.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <20080804151146.71d9fcce@lxorguk.ukuu.org.uk>
	 <1217869134.24714.70.camel@koto.keithp.com>
	 <200808042346.51391.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 7:46 AM, Ingo Oeser <ioe-lkml@rameria.de> wrote:
> On Monday 04 August 2008, Keith Packard wrote:
>> On Mon, 2008-08-04 at 15:11 +0100, Alan Cox wrote:
>>
>> > X libraries provide the event loop so that isn't really as complex as it
>> > seems.
>>
>> Uh, no, X doesn't. Gtk+ and Qt provide event loops that applications may
>> use, but still many choose to roll their own.
>
> Ok, how many need support for GEM? How many of them would change their
> event loop, if they can get better performance?
>

GEM is under OpenGL libs so they don't request support for GEM.
However if the underlying OpenGL implemenation
suddenly starts doing something with a lot of fds it could potentially
confuse the crap out of these exisiting applications.

Dave.
