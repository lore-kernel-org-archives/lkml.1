Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXKGC22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXKGC22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXKGC2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:28:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36239 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752410AbXKGC2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:28:20 -0500
Date: Tue, 6 Nov 2007 18:28:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/10] split anon and file LRUs
In-Reply-To: <20071103190158.34b4650e@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711061825590.5249@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
 <20071103190158.34b4650e@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Rik van Riel wrote:

> Split the LRU lists in two, one set for pages that are backed by
> real file systems ("file") and one for pages that are backed by
> memory and swap ("anon").  The latter includes tmpfs.

If we split the memory backed from the disk backed pages then
they are no longer competing with one another on equal terms? So the file LRU 
may run faster than the memory LRU?

The patch looks awfully large.
