Return-Path: <linux-kernel-owner+w=401wt.eu-S1764848AbXIXRBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764848AbXIXRBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759579AbXIXRB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:01:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1486 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561AbXIXRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:01:26 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Joe Perches <joe@perches.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: holzheu@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <19f34abd0709240943s13472c97ma7a4aff3a6089e8f@mail.gmail.com>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190625742.12666.30.camel@localhost.localdomain>
	 <1190647156.30132.92.camel@localhost>
	 <19f34abd0709240943s13472c97ma7a4aff3a6089e8f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 10:00:50 -0700
Message-Id: <1190653250.2010.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 18:43 +0200, Vegard Nossum wrote:
> Storing the format-string separately allows us to hash THAT instead of
> the formatted (ie. console output) message. Since this will never
> change from message to message, it can be looked up in a table or
> whatever and allow user-space to do translations without for example
> regular expressions.

That hash will change with each linux version given the
inevitable spelling fixes, message reformatting and such.

> I will follow up with some code to demonstrate as soon as I can.

Looking forward to it.

