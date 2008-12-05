Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbYLEMS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbYLEMS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYLEMSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:18:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48801 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYLEMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:18:20 -0500
Date: Fri, 5 Dec 2008 13:29:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Mikulas Patocka <mpatocka@redhat.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081205122930.GB6703@one.firstfloor.org>
References: <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com> <20081204174838.GS6703@one.firstfloor.org> <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com> <20081204221551.GV6703@one.firstfloor.org> <Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com> <20081205004849.GX6703@one.firstfloor.org> <Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com> <20081205013739.GZ6703@one.firstfloor.org> <20081205115225.13c277ee@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205115225.13c277ee@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not when the fundamental design of the code is broken and trashes
> performance. 

Sorry but that's just not correct. There's nothing in late failing
barriers that "trashes performance". The file system writers have
to be careful to handle it, but at least the current ones all do.
And also if someone writes a hypothetical fully asynchronously driven 
barrier based IO transaction system it would be still possible to handle 
the late failing barrier without too many complications.

Also late failing barriers is pretty much the only sane way to implement
barriers in software remapping schemes like DM and MD.

-Andi

-- 
ak@linux.intel.com
