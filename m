Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXGCAqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXGCAqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbXGCAqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:46:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:37470 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbXGCAqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IKyF0nzhpo6XNBA4uV5r24Bjvu8O82d9ckOTyDqoAhvjxJWlb/653xqwfP8xn2+WUQfKbF+FkWM5DkgbkSRw2u+9HJmMdqUB94Sq/LdgCASD1Nxg/XfKgoa93MlXiFPG16fhYeSOnH3ra5Z/zjapgH6QYKqXoFF58w0ot0ZAQhA=
Message-ID: <6934efce0707021746q133c62f5l803e5fa78b3535d9@mail.gmail.com>
Date: Mon, 2 Jul 2007 17:46:40 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: vm/fs meetup in september?
Cc: "Christoph Hellwig" <hch@infradead.org>, "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070702230418.GA5630@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070624042345.GB20033@wotan.suse.de>
	 <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com>
	 <20070626060528.GA15134@infradead.org>
	 <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com>
	 <20070630093243.GD22354@infradead.org>
	 <6934efce0707021044x44f51337ofa046c85e342a973@mail.gmail.com>
	 <20070702230418.GA5630@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Jörn Engel <joern@logfs.org> wrote:
> On Mon, 2 July 2007 10:44:00 -0700, Jared Hulbert wrote:
> >
> > >So what you mean is "swap on flash" ?  Defintively sounds like an
> > >interesting topic, although I'm not too sure it's all that
> > >filesystem-related.
> >
> > Maybe not. Yet, it would be a very useful place to store data from a
> > file as a non-volatile page cache.
> >
> > Also it is something that I believe would benefit from a VFS-like API.
> > I mean there is a consistent interface a management layer like this
> > could use, yet the algorithms used to order the data and the interface
> > to the physical media may vary.  There is no single right way to do
> > the management layer, much like filesystems.
> >
> > Given the page orientation of the current VFS seems to me like there
> > might be a nice way to use it for this purpose.
> >
> > Or maybe the real experts on this stuff can tell me how wrong that is
> > and where it should go :)
>
> I don't believe anyone has implemented this before, so any experts would
> be self-appointed.
>
> Maybe this should be turned into a filesystem subject after all.  The
> complexity comes from combining XIP with writes on the same chip.  So
> solving your problem should be identical to solving the rw XIP
> filesystem problem.
>
> If there is interest in the latter, I'd offer my self-appointed
> expertise.

Right, the solution to swap problem is identical to the rw XIP
filesystem problem.    Jörn, that's why you're the self-appointed
subject matter expert!
