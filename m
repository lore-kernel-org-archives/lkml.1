Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbYECCV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbYECCV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 22:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbYECCVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 22:21:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbYECCVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 22:21:48 -0400
Message-ID: <481BCC34.80808@redhat.com>
Date: Fri, 02 May 2008 21:21:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] find dynamic stack allocations in checkstack.pl
References: <481B4EC5.6060507@redhat.com> <20080502223539.GH24080@logfs.org>
In-Reply-To: <20080502223539.GH24080@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Fri, 2 May 2008 12:26:29 -0500, Eric Sandeen wrote:
>> @@ -142,6 +148,22 @@ while (my $line = <STDIN>) {
>>  		next if ($size < 100);
>>  		push @stack, "$intro$size\n";
>>  	}
>> +	elsif (defined $dre && $line =~ m/$dre/) {
> 
> These two could join a line.  Otherwise an excellent addition.

Thanks... was just following the existing style (in this part of the
file, anyway...)

-Eric

> Reviewed-By: Joern Engel <joern@logfs.org>
> 
> Jörn
> 

