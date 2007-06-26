Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbXFZRHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbXFZRHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXFZRH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:07:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:55719 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbXFZRHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dDxXDVS4FVwWPLH9ESMToGTGfzVnIaHqTAw6587xUSSpoSdXtKs90RRp51NIRBRxkPaqaMGiU2Ah1/Ry44u+RBG1Hfw8imS+QrnEhLYylSVfjgjK85vmQbfpKYXyvVRZ2E6IPsGL2ougwJ1qiyi/KVk5/DTrN9OjmIaiHN/ocJs=
Message-ID: <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com>
Date: Tue, 26 Jun 2007 10:07:24 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: vm/fs meetup in september?
In-Reply-To: <20070626060528.GA15134@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070624042345.GB20033@wotan.suse.de>
	 <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com>
	 <20070626060528.GA15134@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 25, 2007 at 05:08:02PM -0700, Jared Hulbert wrote:
> > -memory mappable swap file (I'm not sure if this one is appropriate
> > for the proposed meeting)
>
> Please explain what this is supposed to mean.

If you have a large array of a non-volatile semi-writeable memory such
as a highspeed NOR Flash or some of the similar emerging technologies
in a system.  It would be useful to use that memory as an extension of
RAM.  One of the ways you could do that is allow pages to be swapped
out to this memory.  Once there these pages could be read directly,
but would require a COW procedure on a write access.  The reason why I
think this may be a vm/fs topic is that the hardware makes writing to
this memory efficiently a non-trivial operation that requires
management just like a filesystem.  Also it seems to me that there are
probably overlaps between this topic and the recent filemap_xip.c
discussions.
