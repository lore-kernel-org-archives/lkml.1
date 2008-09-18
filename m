Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYIRXyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYIRXyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbYIRXxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:53:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:63767 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbYIRXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gX9ckqOT6PkMW8uZGW0E0XK3nMTnDE8BGfP0bJEwgz6QH76NiHkObKBj1klDKS5CQB
         UI4x042Ei+atLIkjA+UYae4lsS093tlEMCLtt4X7cM277dMJwlKsQUNM6vOWUtfVRbLC
         Ha+Gg5yhSN0qCkOq3wk0dLJEWTi+uk8EoES7A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 3/4 v2] ide: Implement disk shock protection support
Date: Thu, 18 Sep 2008 16:24:53 -0700
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <87d4j2n3dn.fsf@denkblock.local> <20080917163144.9870.59732.stgit@denkblock.local>
In-Reply-To: <20080917163144.9870.59732.stgit@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809181624.54248.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 09:38:37 Elias Oltmanns wrote:
> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> FEATURE as specified in ATA-7 is issued to the device and processing of
> the request queue is stopped thereafter until the specified timeout
> expires or user space asks to resume normal operation. This is supposed
> to prevent the heads of a hard drive from accidentally crashing onto the
> platter when a heavy shock is anticipated (like a falling laptop expected
> to hit the floor). Port resets are deferred whenever a device on that
> port is in the parked state.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

applied
