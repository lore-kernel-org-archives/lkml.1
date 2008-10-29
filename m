Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYJ2Pif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYJ2Pif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYJ2Pi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:38:27 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35074 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYJ2Pi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:38:27 -0400
Subject: Re: How do I printk <type> correctly?
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       ericvh@gmail.com, mfasheh@suse.com
In-Reply-To: <20081029083403.5afac2c1.randy.dunlap@oracle.com>
References: <20081023114133.GA30187@x200.localdomain>
	 <20081028161136.c652b9fd.randy.dunlap@oracle.com>
	 <1225267204.4350.10.camel@sauron>
	 <20081029083403.5afac2c1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Oct 2008 17:36:50 +0200
Message-Id: <1225294610.4350.19.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Oct 2008 15:38:13.0308 (UTC) FILETIME=[5AA45FC0:01C939DC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 08:34 -0700, Randy Dunlap wrote:
> It's in the C standard, which we don't try to put into Documentation/ AFAIK.
> 
> section 6.5.3.4, The sizeof operator:
> 
> 4 The value of the result is implementation-defined, and its type (an unsigned integer type)
> is size_t, defined in <stddef.h> (and other headers).

Well, OK. I was more thinking about printing stuff like ino_t.
UBIFS used %lu for this which was the source of warnings.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

