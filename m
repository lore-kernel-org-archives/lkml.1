Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXBTU04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXBTU04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 15:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030416AbXBTU04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 15:26:56 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41417 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030405AbXBTU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 15:26:55 -0500
Date: Tue, 20 Feb 2007 12:26:54 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] free swap space when (re)activating page
In-Reply-To: <45DB51E3.8090909@redhat.com>
Message-ID: <Pine.LNX.4.64.0702201226140.16722@schroedinger.engr.sgi.com>
References: <45D63445.5070005@redhat.com> <Pine.LNX.4.64.0702192048150.9934@schroedinger.engr.sgi.com>
 <45DAF794.2000209@redhat.com> <Pine.LNX.4.64.0702200833460.13913@schroedinger.engr.sgi.com>
 <45DB25E1.7030504@redhat.com> <Pine.LNX.4.64.0702201015590.14497@schroedinger.engr.sgi.com>
 <45DB4C87.6050809@redhat.com> <45DB51E3.8090909@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Rik van Riel wrote:

> The attached patch should be correct.

Oh. It vanished again when I replied to your mail.
 
> Btw, why do we not call pagevec_strip on the pages on l_active?
> I assume we want to reclaim their buffer heads, too...

Yes we want to reduce buffer heads if we are over the limit.
