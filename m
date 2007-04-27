Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbXD0QVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbXD0QVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbXD0QVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:21:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbXD0QVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:21:42 -0400
Message-ID: <46322310.1090000@redhat.com>
Date: Fri, 27 Apr 2007 12:21:36 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 18/38] Improved oops output.
References: <20070427140503.087958775@de.ibm.com>	 <20070427140516.013904506@de.ibm.com>	 <20070427142506.GA12738@infradead.org> <1177687465.23773.2.camel@localhost>	  <46321E5E.9010909@redhat.com> <1177690548.23773.13.camel@localhost>
In-Reply-To: <1177690548.23773.13.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
>> No ksymoops for your architecture?
> 
> There is ksymoops for s390 and it should be able to disassemble the code
> as well. But you need all sorts of files to feed into ksymoops to get
> something out of it. At least I often get bug reports with the console
> output attached and it simply saves time if I can see the disassembly
> without an extra step.
> 

The only file you need on i386 is the oops itself. ksymoops will scream
about missing files but will still work for disassembly.
