Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYCXUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYCXUhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYCXUhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:37:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37431
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbYCXUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:37:23 -0400
Date: Mon, 24 Mar 2008 13:37:22 -0700 (PDT)
Message-Id: <20080324.133722.38645342.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
	<20080321.145712.198736315.davem@davemloft.net>
	<Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Mon, 24 Mar 2008 11:27:06 -0700 (PDT)

> The move to 64k page size on IA64 is another way that this issue can
> be addressed though.

This is such a huge mistake I wish platforms such as powerpc and IA64
would not make such decisions so lightly.

The memory wastage is just rediculious.

I already see several distributions moving to 64K pages for powerpc,
so I want to nip this in the bud before this monkey-see-monkey-do
thing gets any more out of hand.
