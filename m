Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYHBCwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYHBCwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYHBCvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:51:55 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:21676 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbYHBCvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Nqq789e1BhcIdyM5kYTcbopDql+2wC//cbnNz4xKW6gvzOzaOV+txQ4/d1RluU8Eh1
         2V5U8djsJT65bH1mdSbwyDG807DBA1CH4fMCmUxBDD9mI9pRQX9D0kFr/WO+ntN7NXNO
         KEVbYg5bfz2K0GFR6Xz7EiqnJMcsUsjOCZIIM=
Message-ID: <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
Date: Fri, 1 Aug 2008 21:51:53 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200808012319.05038.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <200808012319.05038.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/1 Alistair John Strachan <alistair@devzero.co.uk>:
> On Friday 01 August 2008 18:30:34 Linas Vepstas wrote:
>> Hi,
>>
>> I'm seeing strong, easily reproducible (and silent) corruption on a
>> sata-attached
>> disk drive on an amd64 board.  It might be the disk itself, but I
>> doubt it; googling
>> suggests that its somehow iommu-related but I cannot confirm this.
>
> Nowhere do you explicitly say you have memtest86'ed the RAM.

It passes memtest86+ just fine. The system has been in heavy
use doing big science calculations on big datasets (multi-gigabyte)
for months; these do not get corrupted when copied/moved around
on the old parallel IDE disk, nor moving/copying on an NFS mount
to a file server. Only the SATA disk is misbehaving.

--linas
