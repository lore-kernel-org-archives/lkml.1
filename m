Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbYBZJ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbYBZJ03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762085AbYBZJZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:25:45 -0500
Received: from mail2.shareable.org ([80.68.89.115]:55577 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761735AbYBZJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:25:42 -0500
Date: Tue, 26 Feb 2008 09:25:37 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226092536.GA9213@shareable.org>
References: <20080226072649.GB30238@shareable.org> <47C3C33F.1070908@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C3C33F.1070908@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> [snip huge long proposal]
> 
> Rather than invent new APIs, we should fix the existing ones to _really_ 
> flush data to physical media.

Btw, one reason for the length is the current block request API isn't
sufficient even to make fsync() durable with _no_ new APIs.

It offers ordering barriers only, which aren't enough.  I tried to
explain, discuss some changes and then suggest optimisations.

-- Jamie
