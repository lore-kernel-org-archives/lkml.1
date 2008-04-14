Return-Path: <linux-kernel-owner+w=401wt.eu-S1762924AbYDNSA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924AbYDNSA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYDNSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:00:50 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57652 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754796AbYDNSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:00:49 -0400
Date: Mon, 14 Apr 2008 11:00:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
In-Reply-To: <20080413135344.60dc2e05.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804141058560.6296@schroedinger.engr.sgi.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
 <20080413204422.GA5136@martell.zuzino.mipt.ru> <20080413135344.60dc2e05.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008, Andrew Morton wrote:

> Yes, I don't think the sub changes are ready for prime-time.

At this point there is no tie in with slub changes. This is 
freepointer corruption that is typical for writing to the object after 
free it. Enabling slub debugging is needed to figure out when the object 
was overwritten.


