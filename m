Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYCDFjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYCDFjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYCDFjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:39:02 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35150 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752603AbYCDFjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:39:01 -0500
Date: Mon, 3 Mar 2008 21:38:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [rfc 10/10] Pageflags: Land grab
In-Reply-To: <p73tzjn5ld0.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0803032138140.8055@schroedinger.engr.sgi.com>
References: <20080304000452.514878384@sgi.com> <20080304000734.383475547@sgi.com>
 <p73tzjn5ld0.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Andi Kleen wrote:

> I have an upcoming, soon to be posted, project that needs one page
> flag on 32bit and two on 64bit. I would request that you leave
> at least that many over.

There are 2 left on 32 bit (if one does not use classic sparsemem which 
x86_64 does not do) and 7 on 64 bit.
