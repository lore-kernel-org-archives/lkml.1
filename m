Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbYHIAnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbYHIAnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYHIAnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:43:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39401 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHIAnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:43:41 -0400
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
In-Reply-To: <200808090039.20289.arnd@arndb.de>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808090013.41999.arnd@arndb.de> <1218234411.19082.58.camel@nimitz>
	 <200808090039.20289.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 17:43:34 -0700
Message-Id: <1218242614.19082.65.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-09 at 00:39 +0200, Arnd Bergmann wrote:
> The main problem I see with that would be atomicity: If you want multiple
> processes to keep interacting with each other, you need to save them at
> the same point in time, which gets harder as you split your interface into
> more than a single file descriptor.

It could take ages to write out a checkpoint even to a single fd, so I
suspect we'd have the exact same kinds of issues either way.

-- Dave

