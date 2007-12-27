Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbXL0PA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbXL0PA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 10:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXL0PAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 10:00:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:21752 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXL0PAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 10:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hGsRk8fUA75T0mOCSY0mKauN5Qa9oUZAysc01ANvx7XJ9n9AkahFHrVXYxDlusrzSeA9Zn/stvou36DN/KpZADqkVp5cXbJHX8+bnTPOVCo6eH4TV6KJuCK61kPOY1/81D5Sh8r7TP/mQSdhR6V9sFv4By3uWhx/7wU2qDcxymQ=
Message-ID: <c70ff3ad0712270700h6336b194r7c21834423aeb331@mail.gmail.com>
Date: Thu, 27 Dec 2007 17:00:12 +0200
From: "saeed bishara" <saeed.bishara@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: read-ahead in NFS server
Cc: linux-kernel@vger.kernel.org, "NFS list" <linux-nfs@vger.kernel.org>
In-Reply-To: <47739288.7000308@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com>
	 <47730F2F.3080900@garzik.org>
	 <c70ff3ad0712270050u134616d1q459ed073c586dcec@mail.gmail.com>
	 <47739288.7000308@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Are you using TCP?  Are you using NFSv4, or an older version?
> > I'm using NFSv3/UDP.
>
> IMO, you definitely want TCP and NFSv4.  Much better network behavior,
> with some of the silly UDP limits (plus greatly improved caching
> behavior, due to v4 delegations).
the clients of my system going to be embedded system with low
performance cpus and I need UDP as it needs less cpu power.

> > when I run local dd with bs=4K, I can see that the average IO size is
> > more than 300KB.
>
> Read-ahead is easier in NFSv4, because the client probably has the file
> delegated locally, and has far less need to constantly revalidate file
> mapping(s).
I'll check that.
but what about the server side? why the issued IO's are only as twice
as the size of the NFS requests?
