Return-Path: <linux-kernel-owner+w=401wt.eu-S964947AbYBWIYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947AbYBWIYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbYBWIJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:41 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765741AbYBWIJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:29 -0500
Date: Sat, 23 Feb 2008 00:04:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, xemul@openvz.org, balbir@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
Message-Id: <20080223000426.adf5c75a.akpm@linux-foundation.org>
In-Reply-To: <47BE4FB5.5040902@linux.vnet.ibm.com>
References: <20080221203518.544461000@menage.corp.google.com>
	<20080221205525.349180000@menage.corp.google.com>
	<47BE4FB5.5040902@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 09:59:41 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> menage@google.com wrote:
> > Update the memory controller to use read_uint for its
> > limit/usage/failcnt control files, calling the new
> > res_counter_read_uint() function.
> > 
> > Signed-off-by: Paul Menage <menage@google.com>
> > 
> 
> Hi, Paul,
> 
> Looks good, except for the name uint(), can we make it u64(). Integers are 32
> bit on both ILP32 and LP64, but we really read/write 64 bit values.
> 

yup, I agree.  Even though I don't know what ILP32 and LP64 are ;)
