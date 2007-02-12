Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXBLUK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXBLUK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965278AbXBLUK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:10:28 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:14919 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965288AbXBLUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:10:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qx7sPegIcQO/FWtbx8ZKebY4m1sh5C/SV53jw9eQmfslt1VwhBowkkGrxC5HKQ3g4xedCYRLsyKCWb9Mf/vJU212xV7wQz3ZP1XeThp/4nZP7bQsFx1ScPq7JlamEK4E9crPX5NEd4eTtBOQMtn2n8I7DGYQw3OZkmM5ZlSYtg8=
Message-ID: <45D0C9A0.1030707@gmail.com>
Date: Mon, 12 Feb 2007 12:10:08 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_via: fix resource-managed iomap conversion
References: <20070210010914.GA19717@havoc.gtf.org> <20070210054629.GA4395@gentoox2.trippelsdorf.de> <45CF93D1.9080009@gmail.com> <20070212025843.GA4406@gentoox2.trippelsdorf.de> <45D0B740.9050704@gmail.com> <20070212193302.GA5003@gentoox2.trippelsdorf.de>
In-Reply-To: <20070212193302.GA5003@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> On Mon, Feb 12, 2007 at 10:51:44AM -0800, Tejun Heo wrote:
>> Conversion to resource-managed iomap was buggy causing init failures
>> on both vt6420 and 6421 - BAR5 wasn't mapped for both controllers
>> while on vt6420 sata_via tried to map BAR0-4 twice.  Fix it.

Great, can anyone verify this on vt6421?

-- 
tejun
