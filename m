Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbXCTDi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbXCTDi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 23:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933175AbXCTDi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 23:38:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:52656 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876AbXCTDi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 23:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=IqPQwjapSJfv260UopJszWNT3pwgOp39i635HuyW/CrCnMxRYAg9Qnp6Yv5XYYf0XduImvFfYY+Y5hM/Pdwox21duXYrYjEH/7riVU/dVIde/CEpIEmRTIKg6+Inkepp7THAuhdQVzFzscAA1QBLHb/Ell4PiQowdZhD9in9ak0=
Message-ID: <45FF5749.6010407@gmail.com>
Date: Tue, 20 Mar 2007 12:38:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tony Vroon <chainsaw@gentoo.org>
CC: Jeff Garzik <jgarzik@pobox.com>, alan@lxorguk.ukuu.org.uk,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22 3/3] Add LED trigger to libata core
References: <20070319214907.094B65B80F2@ganymede.vroon.org>
In-Reply-To: <20070319214907.094B65B80F2@ganymede.vroon.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> The first user of ata_ac_issue_prot_with_ledtrigger, the ServerWorks Frodo/
> Apple K2 driver. Used by the IDE LED trigger on G5 towers.
> Respin of an earlier patch, based on comments by Tejun Heo & Alan Cox.

Just two comments.

1. IMHO, ata_qc_issue_prot_ledtrigger() without 'with' is good enough. 
This is just my personal preference.  Feel free to ignore it.

2. Patch #1 and #2 should be merged.  They're one logical change of 
adding ata_qc_issue_prot_with_ledtrigger().  Patch #3 is a logically 
separate change of using it, but unless it's a wide conversion, 
implementing something and using something can be merged.  So, please 
merge #1 and #2 and possibly #3.

Thanks.

-- 
tejun
