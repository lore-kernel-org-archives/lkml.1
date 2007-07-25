Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbXGYPvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbXGYPvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXGYPvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:51:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:35121 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764AbXGYPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mSgYFG6bOXMWbbsXHlCGUp36KwGZyzVXRLsNX4UyyvVaTowlz51eivny1AGEZt3KZK+ChN7ZjFhlNuPBmPnNO2raVsoiRbFCkD923IMzRpg4is4p8xL+7tqGkeNsPoDVjekB/144NGWnKuJ5E7KvUGigBpQUlhWQtCLt0QE1IWM=
Message-ID: <86802c440707250851g2c1138d6g59cc97d013d7aae7@mail.gmail.com>
Date: Wed, 25 Jul 2007 08:51:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr, shaohua.li@intel.com
In-Reply-To: <200707250716.44609.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707240948.45916.bjorn.helgaas@hp.com>
	 <20070725094554.55c46d8b@frecb000686.frec.bull.fr>
	 <200707250716.44609.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> The _DDN is a "DOS device name", and the _UID is a "logical device ID
> that does not change across reboots."  Both are optional, and PNPACPI
> ignores them.  But maybe we could change PNPACPI to sort by them if
> they are present.  I'll think about this a bit.
>
this happen with muliti peer root buses too.
some DSDT put bus 0x80 before  0x0. So the bus 0x80 is scanned by the
kernel at first. so some device such as nic number is reversed too...

need to make some change to acpica...

YH
