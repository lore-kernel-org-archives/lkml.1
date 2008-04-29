Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbYD2N2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbYD2N2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYD2N17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:27:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24088 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbYD2N17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:27:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=x7RsowEj5xvD4u9pSEnlLwdm/IjUhXrzPxcXfYDiTKGyvfI4qp0AebpkbEvyC2ZoY
	/0JVeqJ+bhBTQrf9P3xuw==
Message-ID: <d43160c70804290627g77a74e48k5a383dd441177293@mail.gmail.com>
Date: Tue, 29 Apr 2008 09:27:53 -0400
From: "Ross Biro" <rossb@google.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 1/2] MM: Make page tables relocatable -- conditional flush (rc9)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mel@skynet.ie, apm@shadoween.org
In-Reply-To: <Pine.LNX.4.64.0804161221060.14718@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414163933.A9628DCA48@localhost>
	 <20080414155702.ca7eb622.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0804161221060.14718@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 3:22 PM, Christoph Lameter <clameter@sgi.com> wrote:
>  The patch is interesting because it would allow the moving of page table
>  pages into MOVABLE sections and reduce the size of the UNMOVABLE
>  allocations signficantly (Ross: We need some numbers here). This in turn

Is there a standard test used to evaluate kernel memory fragmentation?
 I'm sure I can rig up a test to create huge amounts of fragmentation
with about 1/2 the pages being page tables.  However, I doubt that it
would reflect any real loads.  Similarly, if I check the memory
fragmentation on my test system right after it's been booted, I won't
see much fragmentation and page tables won't be causing any trouble.

    Ross
