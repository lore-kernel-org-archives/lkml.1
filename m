Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbXE3WX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbXE3WX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbXE3WW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:22:59 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:50402 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758375AbXE3WW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SK4gpr2AcUFV+2ODzOqgdOEd6b4d2pjQBvQ3qcMdsx5Otmms+gnTDTX5VwUQjFm8A/s9k6yOkTTFxxnr5DaPoroIVbWSunMbdjxwFWXHr6TlJezlIidf8oWFziYUkHfbwUwvBYfDxKJX65uF2+Fp3VyAiBGLpRx/wghWMt1iayo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Junio C Hamano <junkio@cox.net>
Subject: Re: [PATCH 1/3] ide_in_drive_list(): accept NULL as the wildcard for firmware revision.
Date: Wed, 30 May 2007 22:43:52 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
References: <20070521145042.GA6957@redhat.com> <200705282141.42507.bzolnier@gmail.com> <7v4plw8ryk.fsf@assigned-by-dhcp.cox.net>
In-Reply-To: <7v4plw8ryk.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705302243.52668.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007, Junio C Hamano wrote:
> Earlier, the matching of (model,rev) in ide-dma black/white list
> handling was to consider "ALL" in the table to match any
> revision.  This makes NULL to be also an accepted wildcard, and
> changes the entries of tables in ide-dma.c to use NULL.
> 
> The code still accepts "ALL" as the wildcard, in order to keep
> any out-of-tree ide driver that feeds its own table that uses
> "ALL" as the wildcard to ide_in_drive_list() function from
> breaking.
> 
> Signed-off-by: Junio C Hamano <junkio@cox.net>

applied
