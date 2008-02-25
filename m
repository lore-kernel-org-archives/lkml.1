Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYBYTqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYBYTqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYBYTqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:46:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41322 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbYBYTqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:46:36 -0500
From: Dave McCracken <dave.mccracken@oracle.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: Page scan keeps touching kernel text pages
Date: Mon, 25 Feb 2008 13:46:32 -0600
User-Agent: KMail/1.9.7
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20080224144710.GD31293@lazybastard.org> <20080225185319.GA14699@lazybastard.org> <20080225192127.GA20322@shadowen.org>
In-Reply-To: <20080225192127.GA20322@shadowen.org>
Organization: Oracle Corp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802251346.32289.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008, Andy Whitcroft wrote:
> I thought that init sections were deliberatly pushed to the end of the
> kernel when linked, cirtainly on my laptop here that seems to be so.
> That would make the first two "after" the kernel.  The other two appear
> to be before the traditional kernel load address, which is 0x100000, so
> those pages are before not in the kernel?

I believe the memory below the kernel load address on x86 is returned to the 
free memory pool at some point during boot, which would explain those 
addresses.

Dave McCracken
