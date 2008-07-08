Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYGHMEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYGHMEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYGHMEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:04:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57071 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbYGHMEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:04:12 -0400
Subject: Re: [PATCH 4/5] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com
In-Reply-To: <Xine.LNX.4.64.0807081127550.10307@us.intercode.com.au>
References: <20080707192529.489789904@linux.vnet.ibm.com>
	 <1215467860.27626.6.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0807081127550.10307@us.intercode.com.au>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 08:04:06 -0400
Message-Id: <1215518646.5013.47.camel@new-host>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-08 at 11:31 +1000, James Morris wrote: 
> On Mon, 7 Jul 2008, Mimi Zohar wrote:
> 
> > (Details on the calls and their exact arguments are in linux/integrity.h,
> > included in the patch.)
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Please summarize what's changed in this patch since the last posting.  
> 
> 
> 
> - James

Based on your suggestions, 
- LIST_HEAD is used to initialize integrity_templates.
- register_template simply rejects an attempt to register a new
template, instead of truncating the name, when the template_name is
too long.
- integrity_find_template() now returns 0 on success and -EINVAL,
instead of 1, on failure, simplifying the callers code.

Mimi

