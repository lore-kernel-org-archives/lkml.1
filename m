Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYIHP4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYIHP4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYIHP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:56:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55252 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbYIHP4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:56:06 -0400
Subject: Re: [RFC v3][PATCH 4/9] Memory management (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <48C3343D.9000407@cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040403120.5982@takamine.ncl.cs.columbia.edu>
	 <1220552725.23386.46.camel@nimitz>  <48C3343D.9000407@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 08:55:06 -0700
Message-Id: <1220889306.23386.147.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 21:54 -0400, Oren Laadan wrote:
> The length of the array may be tunable, or even adaptive (e.g. based
> on statistics from recent checkpoints), in the future.

I'm not sure "tuning" it to make those arrays longer than PAGE_SIZE will
ever be a good idea.  Seems like we should just keep the structures at
PAGE_SIZE to me.

-- Dave

