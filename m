Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZHQQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZHQQo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZHQQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:44:27 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:57692 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZHQQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:44:27 -0400
Date: Mon, 17 Aug 2009 10:06:49 -0700 (PDT)
From: Vincent Li <macli@brc.ubc.ca>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/proc/base.c: fix proc_fault_inject_write() input
 sanity check
In-Reply-To: <20090817024858.GG5039@cr0.nay.redhat.com>
Message-ID: <alpine.DEB.1.00.0908171002060.28933@mail.selltech.ca>
References: <1250281120-3308-1-git-send-email-macli@brc.ubc.ca> <20090817024858.GG5039@cr0.nay.redhat.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Amerigo Wang wrote:

> On Fri, Aug 14, 2009 at 01:18:40PM -0700, Vincent Li wrote:
> >Remove obfuscated zero-length input check and return -EINVAL instead of -EIO error
> >to make the error message clear to user. Add whitespace stripping. No functionality changes.
> 
> If so, why not introduce a new wrapper which is simply strstrip+simple_strtol?
> Now, at least it has two users.

The first patch I sent used strstrip + strict_strtol, I am not sure if it 
is neccesary.

Vincent Li
Biomedical Research Center
University of British Columbia
