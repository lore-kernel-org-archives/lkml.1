Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZF3V7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZF3V7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZF3V66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:58:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbZF3V65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:58:57 -0400
Date: Tue, 30 Jun 2009 14:57:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lenb@kernel.org, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org, feng.tang@intel.com, len.brown@intel.com
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-Id: <20090630145737.de5de4af.akpm@linux-foundation.org>
In-Reply-To: <20090623072811.GB6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
	<b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
	<20090623072811.GB6397@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 09:28:11 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > +/*
> > + * Table structures must be byte-packed to match the SFI specification,
> > + * as they are provided by the BIOS.
> > + */
> > +#pragma pack(1)
> 
> We use __attribute__((packed)) for that generally.

Or __packed.  I usually recommend __packed because I can never remember
the weird arrangement of underscores and parentheses in the gcc thing.
