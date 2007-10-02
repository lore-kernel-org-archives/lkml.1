Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbXJBLX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbXJBLX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXJBLXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:23:51 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:59448 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXJBLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eGIJVAt2FMmjKqh31IfqP5wbNj1ZEmCsUbfd8BmrumwtRr2mPHWLGoHeITzPFUIS44KdoGFcIMOl9cIgkfyUBQsSpnDgPTurwOiygd0LhuybQvhcZ0zlouYwcUzT48pN6C6DZiwpjHUjpAkjqZBAaB6dmYUkbx5MDRpXiPrJkBg=
Message-ID: <3ae72650710020422r5d873289j3d1565dfa21e1ede@mail.gmail.com>
Date: Tue, 2 Oct 2007 13:22:32 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Fengguang Wu" <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <391322057.11200@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <1191313025.13204.30.camel@twins>
	 <20071002013148.18958af2.akpm@linux-foundation.org>
	 <1191314911.13204.41.camel@twins>
	 <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com>
	 <1191321861.13204.53.camel@twins> <391322057.11200@ustc.edu.cn>
X-Google-Sender-Auth: ee61a9dd45111b5b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Tue, Oct 02, 2007 at 12:44:21PM +0200, Peter Zijlstra wrote:
> > On Tue, 2007-10-02 at 12:31 +0200, Kay Sievers wrote:
> >
> > > What would be the point in another top-level tree for device
> > > information? All devices you are exporting information for, are
> > > already in the sysfs tree, right?
> >
> > Never did find NFS mounts/servers/superblocks or whatever constitutes a
> > BDI for NFS in there. Same goes for all other networked filesystems for
> > that matter.
>
> And loop/md/dm devices...

Hmm, /sys/block/mdX, /sys/block/loopX, /sys/block/dm-X are all there today.

Kay
