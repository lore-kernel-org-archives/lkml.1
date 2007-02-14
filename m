Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbXBNKss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbXBNKss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932196AbXBNKss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:48:48 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:51369 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbXBNKsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vd+0F1yEoIla1vcJsQJngVHd5tvQCExl7WY0srRSSlB6dwcpJgqWucEM7oMydZOK1WDB6UkaBD8CLmvJ9mPtOhgjqSZrkGR5i8mBDaf62JZJhgEMMPNMETsBJvGVwYaX3WA2JGwFdJnwiuMfUloFm46lJhKqDpJqo4WXIfk4+SQ=
Message-ID: <8d158e1f0702140248h63d99e3hdf4ccc155f5fdef6@mail.gmail.com>
Date: Wed, 14 Feb 2007 11:48:45 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Ramy M. Hassan" <ramy@gawab.com>
Subject: Re: xfs internal error on a new filesystem
Cc: linux-kernel@vger.kernel.org, "Ahmed El Zein" <a.elzein@gawab.net>
In-Reply-To: <20070214102432.6346.qmail@info6.gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070214102432.6346.qmail@info6.gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Ramy M. Hassan <ramy@gawab.com> wrote:
> Hello,
> We got the following xfs internal error on one of our production servers:

Hi, I want firstly to make a disclaimer that I am not an XFS or kernel
guru, what I am writing now is purely my experience, since I use XFS
on all my machines, on different disks and all.


I encountered the problem you have now, twice over the past three years.
Once it was caused by a faulty disk where the 8MB cache on the disk
was faulty, causing corruption, and one time it was cause of, what
seems to be, a CPU that couldnt handle XFS. This sounds illogical, and
to me too, honestly, but the explanation I got was that XFS writes are
quite CPU intensive, especialy when you write with 500MB/s and we
tried to do this on a PII-400Mhz.

I tried reiserfs aswell, and I honestly cant give you one reason to
switch back to it. I love XFS, always did, its fast and reliable.
Problems that I had were never related to XFS but to hardware that had
to deal with XFS in a way (CPU/disk).

And, xfs_repair DID repair my filesystems, the data was on the disks,
and valid, XFS just shut down my filesystem cause it found my journal
not reliable/corrupted.

Again, please be aware that I am just a regular user who likes to play
around with linux and the kernel, I am no expert in the field of XFS
or its relations.


I hope this helps you a bit.


Patrick
