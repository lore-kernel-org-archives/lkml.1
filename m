Return-Path: <linux-kernel-owner+w=401wt.eu-S965718AbXAYIrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965718AbXAYIrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965720AbXAYIrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:47:13 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48300 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965718AbXAYIrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:47:11 -0500
Date: Thu, 25 Jan 2007 09:46:10 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 4/5][AIO] - AIO completion signal notification
Message-ID: <20070125094610.4b356620@frecb000686>
In-Reply-To: <20070125054242.GA8799@infradead.org>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105018.7213ed7c@frecb000686>
	<20070123213513.2454b24d.akpm@osdl.org>
	<20070124121130.0dfc8573@frecb000686>
	<20070125054242.GA8799@infradead.org>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 09:47:53,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 09:48:01,
	Serialize complete at 25/01/2007 09:48:01
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 05:42:42 +0000 Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jan 24, 2007 at 12:11:30PM +0100, S?bastien Dugu? wrote:
> > > > +	if (unlikely(!notify->sigq))
> > > > +		return -EAGAIN;
> > > 
> > > Did this just leak a ref on the task_struct?
> > > 
> > 
> >   No, the ref is released in really_put_req() when we dispose of
> > the iocb.
> 
> And the code really needs a comment explaining this.  I tripped over
> this before, and I think it's even already the second time Andrew
> stumbled over it.
> 

  OK, will do.

  Thanks,

  Sébastien.
