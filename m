Return-Path: <linux-kernel-owner+w=401wt.eu-S934604AbZDBCOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604AbZDBCOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbZDBCOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:14:14 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:46914 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654AbZDBCON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:14:13 -0400
Date: Wed, 1 Apr 2009 22:09:35 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: ngupta@vflare.org
cc: Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       edt@aei.ca, linux-mm-cc@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] compressed in-memory swapping take5
In-Reply-To: <49D400A5.20901@vflare.org>
Message-ID: <alpine.DEB.1.10.0904012207110.32656@qirst.com>
References: <49D0DBA2.20101@vflare.org> <20090401155743.685e2c1e.akpm@linux-foundation.org> <49D400A5.20901@vflare.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Nitin Gupta wrote:

> Justification for this custom allocator is present in xvmalloc changelog
> itself. It gives reason for not using SLUB and SLOB. During review
> cycle, I never got any arguments against that justification.

The use of highmem is pretty unique. But that restrict the usefulness to
32 bit processors with too much RAM.

