Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYIXUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYIXUH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIXUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:07:15 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:11726 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYIXUHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jDKqiYHPXzzTC/XIOAUqeS4E6ZZ37Apdkwc/h3SxNdNe+pPw2a77hUbv6cHyBt1Jgj
         bydgr7XKq79GphiGHFLhUF9JlxvicuppLqk4oFIZITik+lpBgAfpA1rED3CjytKKHqJa
         x7YG/XILL37+uXDShTJ4yD64Q2D1t3Be02jgA=
Message-ID: <21d7e9970809241307p2a0e68e0odcf69acff8fe9420@mail.gmail.com>
Date: Thu, 25 Sep 2008 06:07:12 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "David Miller" <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
In-Reply-To: <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	 <20080924.003638.71148740.davem@davemloft.net>
	 <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>
	 <20080924.020116.193720569.davem@davemloft.net>
	 <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com>
	 <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 2:33 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 24 Sep 2008, Dave Airlie wrote:
>
>> Hopefully tglx can supply some traces, I think getting an interrupt
>> during device startup can possibly access the nvram
>> http://www.tglx.de/~tglx/wtf2.txt
>> seems to suggest bad things could happen.
>
> Actually another user has just reported [1] that his e1000e card got
> screwed up exactly at the point when the installer was probing the X
> configuration. So this really seems a lot like some lethal interaction
> between intel graphics and the network card.
>
> Dave (Airlie, too many Daves on CC here really), do you by any chance see
> any recent change in kernel intel graphic parts of DRM be causing this
> breakage?
>

Okay some from the kernel if this isn't in 2.6.26, the drm has
introduced no patches
I can even remotely claim might affect this. So its either userspace
or PAT related.

Dave.
