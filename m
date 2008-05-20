Return-Path: <linux-kernel-owner+w=401wt.eu-S1764229AbYETLgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764229AbYETLgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYETLgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:36:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57045 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYETLga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:36:30 -0400
Date: Tue, 20 May 2008 05:36:29 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, greg@kroah.com,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Message-ID: <20080520113629.GK2638@parisc-linux.org>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com> <20080520030232.fc91b64e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520030232.fc91b64e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 03:02:32AM -0700, Andrew Morton wrote:
> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > Converting class semaphore to mutex cause lockdep warnings due to
> > class_interface_register/unregister will possible call device_add/del
> 
> Shouldn't we just fix that?

That's what I suggested (in a thread you were cc'd on, but probably
aren't reading).  I don't like this reclassify thing either.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
