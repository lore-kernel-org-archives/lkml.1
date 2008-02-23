Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYBWOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYBWOdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYBWOdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:33:43 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYBWOdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:33:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XNvAzGfEkURbocC6dwE/+Xh/xBzOUnB7EXGyQSJfCyes3cbsE3lfaWJpdf0M1lTTf
	FTqiq1XRtRMm4Ee8Tyo8A==
Message-ID: <6599ad830802230633i483c8dd1q5b541be1a92a5795@mail.gmail.com>
Date: Sat, 23 Feb 2008 06:33:34 -0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
Cc: akpm@linux-foundation.org, xemul@openvz.org, balbir@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <47BE4FB5.5040902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221203518.544461000@menage.corp.google.com>
	 <20080221205525.349180000@menage.corp.google.com>
	 <47BE4FB5.5040902@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 8:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  Looks good, except for the name uint(), can we make it u64(). Integers are 32
>  bit on both ILP32 and LP64, but we really read/write 64 bit values.

Yes, that's true. But read_uint() is more consistent with all the
other instances in cgroups and subsystems. So if we were to call it
res_counter_read_u64() I'd also want to rename all the other
*read_uint functions/fields to *read_u64 too. Can I do that in a
separate patch?

Paul
