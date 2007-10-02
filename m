Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbXJBLVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbXJBLVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXJBLVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:21:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:1129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbXJBLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C/wxyN2R/VAAkaGKAZpcVyM7/cHL5YKTdEdVE78XfVxZ+cFlmNZZ1nE9QwrVXro915a7fwKEYarP6YjNgklfIm/R25Oxnc175DPOzCVsa+fMAoY0z/GXE8t9NZ/GXc99IP2e3e/zGO8UFjyQIlXb+7N0tMGX752Tp3hx1sFuaAU=
Message-ID: <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
Date: Tue, 2 Oct 2007 13:21:30 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Fengguang Wu" <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <1191321861.13204.53.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <1191313025.13204.30.camel@twins>
	 <20071002013148.18958af2.akpm@linux-foundation.org>
	 <1191314911.13204.41.camel@twins>
	 <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com>
	 <1191321861.13204.53.camel@twins>
X-Google-Sender-Auth: f5bf9edcba8d4b6d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2007-10-02 at 12:31 +0200, Kay Sievers wrote:
>
> > What would be the point in another top-level tree for device
> > information? All devices you are exporting information for, are
> > already in the sysfs tree, right?
>
> Never did find NFS mounts/servers/superblocks or whatever constitutes a
> BDI for NFS in there. Same goes for all other networked filesystems for
> that matter.

How about adding this information to the tree then, instead of
creating a new top-level hack, just because something that you think
you need doesn't exist.

You called sysfs a mess, seems you work on that topic too. :)

Kay
