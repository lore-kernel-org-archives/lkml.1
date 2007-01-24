Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbXAXO7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbXAXO7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXAXO7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:59:11 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:58699 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751879AbXAXO7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:59:10 -0500
Date: Wed, 24 Jan 2007 06:56:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
cc: Aubrey Li <aubreylee@gmail.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
In-Reply-To: <45B75208.90208@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0701240655400.9696@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
 <45B75208.90208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, Vaidyanathan Srinivasan wrote:

> With your patch, MMAP of a file that will cross the pagecache limit hangs the
> system.  As I mentioned in my previous mail, without subtracting the
> NR_FILE_MAPPED, the reclaim will infinitely try and fail.

Well mapped pages are still pagecache pages.
 
> I have tested your patch with the attached fix on my PPC64 box.

Interesting. What is your reason for wanting to limit the size of the 
pagecache?

