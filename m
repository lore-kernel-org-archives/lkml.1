Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbXIUKQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbXIUKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbXIUKQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:16:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbXIUKQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:16:18 -0400
Date: Fri, 21 Sep 2007 03:16:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: Reduce Memory Usage for large CPU count
 systems v2
Message-Id: <20070921031606.055ab52e.akpm@linux-foundation.org>
In-Reply-To: <20070920213004.527735000@sgi.com>
References: <20070920213004.527735000@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 14:30:04 -0700 travis@sgi.com wrote:

> Obviously, the IRQ arrays are of greater importance for
> size reduction.  Any suggestions, or threads I should read
> are gratefully accecpted... ;-)

hard.  Convert them to a radix-tree I suppose.  powerpc alrady does that
but it open-codes it in some fashion.  Don't look at it ;)
