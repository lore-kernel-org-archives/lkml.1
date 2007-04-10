Return-Path: <linux-kernel-owner+w=401wt.eu-S1031016AbXDJQTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031016AbXDJQTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031021AbXDJQTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:19:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031016AbXDJQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:19:49 -0400
Message-ID: <461BB8EC.4000900@zytor.com>
Date: Tue, 10 Apr 2007 09:18:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
References: <20070407233037.GA16508@infradead.org>  <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>  <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>  <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>  <1176121897.6210.8.camel@heimdal.trondhjem.org>  <20070409131918.GC18580@thunk.org>  <1176127395.6210.34.camel@heimdal.trondhjem.org>  <20070410135641.GG13650@thunk.org> <1176215836.14442.37.camel@heimdal.trondhjem.org> <Pine.LNX.4.61.0704101750420.21664@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704101750420.21664@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> I had a thought, but I think it's not quite ripe..
> 
> NFS server sends the whole directory contents on NFS client opendir,
> so that the whole readdir/telldir/seekdir magic can happen on the
> client only... which would perhaps also enable a cheap telldir/seekdir,
> and would also give a 'fixed view' when adding/deleting files
> during readdir.
> 

That doesn't sound right... what if there are two million files in the 
directory?

	-hpa
