Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbYBWTAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbYBWTAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbYBWTAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:00:20 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761354AbYBWTAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:00:18 -0500
Date: Sat, 23 Feb 2008 10:59:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, xemul@openvz.org, balbir@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
Message-Id: <20080223105933.e6884808.akpm@linux-foundation.org>
In-Reply-To: <6599ad830802230633i483c8dd1q5b541be1a92a5795@mail.gmail.com>
References: <20080221203518.544461000@menage.corp.google.com>
	<20080221205525.349180000@menage.corp.google.com>
	<47BE4FB5.5040902@linux.vnet.ibm.com>
	<6599ad830802230633i483c8dd1q5b541be1a92a5795@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 06:33:34 -0800 "Paul Menage" <menage@google.com> wrote:

> On Thu, Feb 21, 2008 at 8:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >
> >  Looks good, except for the name uint(), can we make it u64(). Integers are 32
> >  bit on both ILP32 and LP64, but we really read/write 64 bit values.
> 
> Yes, that's true. But read_uint() is more consistent with all the
> other instances in cgroups and subsystems. So if we were to call it
> res_counter_read_u64() I'd also want to rename all the other
> *read_uint functions/fields to *read_u64 too. Can I do that in a
> separate patch?
> 

Sounds sensible to me.
