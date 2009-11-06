Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbZKFW2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbZKFW2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760369AbZKFW2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:28:30 -0500
Received: from adelie.canonical.com ([91.189.90.139]:53031 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363AbZKFW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:28:27 -0500
Date: Fri, 6 Nov 2009 22:28:28 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Removing wrong judgement of checkpatch.pl for
 return as function
Message-ID: <20091106222828.GC5191@penfold>
References: <20091103.104932.625281420231629894.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.104932.625281420231629894.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 10:49:32AM +0900, Hitoshi Mitake wrote:
> 
> Hi,
> 
> I found a strange behaviour of checkpatch.pl.
> 
> The C statement:
> 	return (type)value;
> is regarded as return like a function form by checkpatch.pl.
> So checkpatch.pl causes "Return is not a function." error
> when processing statements like this.
> 
> I think statements like above are innocence. These are only doing type cast.
> This patch removes the behaviour of checkpatch.pl.
> 
> But I don't have confidence about coding style of Linux kernel.
> Is my thought correct? Or the behaviour of current checkpatch.pl is correct?
> Request for comment.

Do you have a patch example which triggers this?  If I test the current
version with this specific fragment I do not get a report.  This one
collapses to '1value' which means it shouldn't trigger the report.

If you do have a specific patch which triggered this could you email it
over, also could you confirm the version of checkpatch which shows this
with checkpatch -v.

Thanks.

-apw
