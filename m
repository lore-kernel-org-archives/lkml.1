Return-Path: <linux-kernel-owner+w=401wt.eu-S970330AbXFHR5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970330AbXFHR5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935013AbXFHR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:56:56 -0400
Received: from lazybastard.de ([212.112.238.170]:46651 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708AbXFHR4z (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:56:55 -0400
Date: Fri, 8 Jun 2007 19:51:53 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608175152.GG20718@lazybastard.org>
References: <4669027E.3070406@de.ibm.com> <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com> <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com> <20070608080401.GA17684@infradead.org> <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com> <20070608160929.GA3366@infradead.org> <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com> <20070608161526.GA3729@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070608161526.GA3729@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 June 2007 17:15:26 +0100, Christoph Hellwig wrote:
> 
> I wouldn't call it that.  The interface should stay the same except that
> write operations are not supported. In mtd_info you'd just have
> point/unpoint and read/read_oob but no write operations and all the backing
> code wouldn't be compiled in aswell.

Nitbit: Sooner or later the point/unpoint should get replaced by
something with page granularity.  Something also needs to keep lists of
mapped pages and invalidate them whenever the device is written to.
That could be done in the filesystem or device driver.  I believe the
device driver would be a better solution.

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
