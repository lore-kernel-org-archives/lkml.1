Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXGBRoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXGBRoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbXGBRoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:44:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:61986 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbXGBRoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jk+Ev2K6QX24xYuN8NK1sWLQzGMvEQTz0kb5uMrINVInqD1bIBfwa56BRagVj07zFAm/yi0fgITGHnSNVLbpO5qDCc8gEdQglqQj9x2sTMl0eKdpvQt6+J9Qvuv5le15gkymVOTy+zAEO1AoVbVAHtlJIW0rKu+V4kmrFtonZEo=
Message-ID: <6934efce0707021044x44f51337ofa046c85e342a973@mail.gmail.com>
Date: Mon, 2 Jul 2007 10:44:00 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: vm/fs meetup in september?
In-Reply-To: <20070630093243.GD22354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070624042345.GB20033@wotan.suse.de>
	 <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com>
	 <20070626060528.GA15134@infradead.org>
	 <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com>
	 <20070630093243.GD22354@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So what you mean is "swap on flash" ?  Defintively sounds like an
> interesting topic, although I'm not too sure it's all that
> filesystem-related.

Maybe not. Yet, it would be a very useful place to store data from a
file as a non-volatile page cache.

Also it is something that I believe would benefit from a VFS-like API.
 I mean there is a consistent interface a management layer like this
could use, yet the algorithms used to order the data and the interface
to the physical media may vary.  There is no single right way to do
the management layer, much like filesystems.

Given the page orientation of the current VFS seems to me like there
might be a nice way to use it for this purpose.

Or maybe the real experts on this stuff can tell me how wrong that is
and where it should go :)
