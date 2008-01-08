Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYAHFX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYAHFX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYAHFXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:23:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49478 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbYAHFXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:23:48 -0500
Date: Mon, 7 Jan 2008 21:23:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bunk@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build-Failure at __you_cannot_kmalloc_that_much
In-Reply-To: <20080107202050.6926ae46@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0801072122550.28636@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
 <478200A4.4090707@linux.vnet.ibm.com> <20080107100733.3655f74f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com>
 <20080107202050.6926ae46@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Arjan van de Ven wrote:

> sounds like a bad idea; a compile time failure is of course nicer than
> a runtime failure for the cases we can find the bug at compile-time already.
> 

There is not much chance of a runtime failure these days since kmalloc now 
supports up to 4MB allocs.
