Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbXDJOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbXDJOKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXDJOKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:10:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:20613 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbXDJOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ou9LvmPZcRoQELDxd5dhsQZtcFLwwpigP0lcQb0/hK1V1uJCH7pY2g9KXB4mQ75yHDW0KqoyjYdnM8tuZNGCotjCszlu6sDNOZLP3qhJ3+xhkyzAyhHwvnJh6cgyYzsRD7k+RUtxUb/U4LOvcr+zngSzSQEXXNYuK6T1trAvpbQ=
Message-ID: <a36005b50704100710i28d5681fsdab6deb1d5161e28@mail.gmail.com>
Date: Tue, 10 Apr 2007 07:10:48 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Ulrich Drepper" <drepper@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
Subject: Re: If not readdir() then what?
In-Reply-To: <20070410135641.GG13650@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070407233037.GA16508@infradead.org>
	 <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org>
	 <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
	 <1176127395.6210.34.camel@heimdal.trondhjem.org>
	 <20070410135641.GG13650@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Theodore Tso <tytso@mit.edu> wrote:
> That might work.  But if in the long term we want to separate out what
> we can send back via telldir/seekdir, and some future new Posix
> interface, [...]

With all these discussions about fixes for telldir, do we want to
persue an alternative interface where the user can explicitly specify
that no telldir/seekdir will ever be used?  From what I know so far it
would make technical sense since we could speed up/reduce the memory
footprint of readdir in 99% of most programs.  But is the benefit
large enough to warrant a second interface?
