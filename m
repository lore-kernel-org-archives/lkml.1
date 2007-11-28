Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbXK1ReL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbXK1ReL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbXK1Rd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:33:56 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39479 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799AbXK1Rdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:33:55 -0500
Subject: Re: [PATCH 06/25] elevate write count open()'d files
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20071128004108.671b96aa.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195256.EDA48D0F@kernel>
	 <20071128004108.671b96aa.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 09:33:44 -0800
Message-Id: <1196271224.18851.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 00:41 -0800, Andrew Morton wrote:
> Given that nameidata_to_filp() can call path_release() which "destroys the
> original nameidata", it looks like this was always buggy? 

It does.  I can see how I introduced the bug, and your fix does look
like a good one.  Thanks.

-- Dave

