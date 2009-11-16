Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZKPXay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZKPXay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZKPXax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:30:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:34396 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZKPXav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=TvZ1JsojMKa3GRyTHEKEiDFgbDEBamHxMAF5OtPvH67RKRlmax2eDzLPBwZeLr+XrP
         qgr4HUaIt02it8R7Y+OjdSoyJw9Uq0NxCIAAmJ5Sfee4TMssYqKAeS7ZJdYBps78Dehv
         lTG2zf4WDSVoWhNWVRTf2vLN1tK54tpSuaYKU=
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.EOH.XTdALB@chimera>
Message-Id: <9872C96C-FAE8-46E8-9588-25D917AF0EAD@gmail.com>
From: Andy Lutomirski <amluto@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <xXQGFmujPl.A.EOH.XTdALB@chimera>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [Bug #14472] EXT4 corruption
Date: Mon, 16 Nov 2009 18:30:24 -0500
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andy Lutomirski <luto@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Shawn Starr <shawn.starr@rogers.com>, Theodore Tso <tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm think this was the journal checksumming bug, which is fixed.

-Andy



On Nov 16, 2009, at 5:37 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me  
> know
> (either way).
>
>
> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14472
> Subject        : EXT4 corruption
> Submitter    : Shawn Starr <shawn.starr@rogers.com>
> Date        : 2009-10-13 2:07 (35 days old)
> References    : http://marc.info/?l=linux-kernel&m=125539997508256&w=4
> Handled-By    : Theodore Tso <tytso@mit.edu>
>
>
