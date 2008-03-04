Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbYCDDae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbYCDDae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763435AbYCDDaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:30:08 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54012 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763320AbYCDDaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:30:06 -0500
Subject: Re: [PATCH 08/14] scsi: replace remaining __FUNCTION__ occurrences
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204600189.22933.88.camel@brick>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
	 <1204600189.22933.88.camel@brick>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 21:30:00 -0600
Message-Id: <1204601400.3043.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-03 at 19:09 -0800, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__

What on earth is the point of this?

We already have compiler specific files in 

include/linux/compiler-*

Which can be used to #define __FUNCTION__ to whatever the individual
compiler wants.  That way we don't get thousands of lines of churn in
the kernel for no value.

James


