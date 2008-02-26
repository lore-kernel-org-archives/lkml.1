Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbYBZQoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbYBZQoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYBZQny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:43:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49186 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYBZQnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:43:53 -0500
Message-ID: <47C441C1.5060305@garzik.org>
Date: Tue, 26 Feb 2008 11:43:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au>
In-Reply-To: <200802262016.11297.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Anyway, the idea of making fsync/fdatasync etc. safe by default is
> a good idea IMO, and is a bad bug that we don't do that :(

Agreed...  it's also disappointing that [unless I'm mistaken] you have 
to hack each filesystem to support barriers.

It seems far easier to make sync_blkdev() Do The Right Thing, and 
magically make all filesystems data-safe.

	Jeff


