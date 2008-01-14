Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYANQS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYANQS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYANQSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:18:17 -0500
Received: from sa14.bezeqint.net ([192.115.104.29]:56167 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYANQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:18:16 -0500
Message-ID: <478B8B41.6060602@panasas.com>
Date: Mon, 14 Jan 2008 18:18:09 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: rdunlap@xenotime.net, apw@shadowen.org, jschopp@austin.ibm.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch.pl failure
References: <1200325734.3159.1.camel@localhost.localdomain>
In-Reply-To: <1200325734.3159.1.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan. 14, 2008, 17:48 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> This error:
> 
> ERROR: no space before that close parenthesis ')'
> #501: FILE: drivers/scsi/dpt_i2o.c:2299:
> +               if (dev_status == 0x02 /*CHECK_CONDITION*/) {
> 
> Is definitely wrong.  I think it's stripped the comments so now the if
> looks to have a space before the bracket, but stylistically the
> complaint it has errored out for is wrong.

I've seen similar complaints as well and I agree with James that
they seem bogus.  I think that the comment should be treated as
part of the grammar and not just stripped out and then you can
even add checks about allowed spacing before and after the comment.

> 
> James
