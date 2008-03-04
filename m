Return-Path: <linux-kernel-owner+w=401wt.eu-S1762449AbYCDDob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762449AbYCDDob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYCDDoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:44:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:46318 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbYCDDoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:44:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HIjZwrVGf3B7GDzr8pVH8gWzOThaWswqUClW5+H07/qcgoHO31B1qkAW65BeleGj4JHZDNc+L4dvMhHLKY6kYHV1EPdwc4V9BWKosA54QPM8Wy3OJM0lTSA+U01OA8OdTF46qoMzheYjueV8F+cxSg2NbcY/lGlBQxnLYQuhaLo=
Subject: Re: [PATCH 08/14] scsi: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204601400.3043.102.camel@localhost.localdomain>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
	 <1204600189.22933.88.camel@brick>
	 <1204601400.3043.102.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:44:19 -0800
Message-Id: <1204602259.22933.103.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 21:30 -0600, James Bottomley wrote:
> On Mon, 2008-03-03 at 19:09 -0800, Harvey Harrison wrote:
> > __FUNCTION__ is gcc-specific, use __func__
> 
> What on earth is the point of this?
> 
> We already have compiler specific files in 
> 
> include/linux/compiler-*
> 
> Which can be used to #define __FUNCTION__ to whatever the individual
> compiler wants.  That way we don't get thousands of lines of churn in
> the kernel for no value.
> 

1) Currently there is a mix of __FUNCTION__ and __func__ in the kernel,
and __func__ is ansi C (C99...)

2) It's shorter

3) When people look around to add new code, they will only see the one
way the kernel does it.

None of which are very convincing, but there you go.

Harvey

