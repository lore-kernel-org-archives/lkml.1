Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZDSRzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZDSRzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 13:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZDSRzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 13:55:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35109 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZDSRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 13:55:09 -0400
Date: Sun, 19 Apr 2009 18:54:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't set relatime when noatime is specified
Message-ID: <20090419175449.GA17263@srcf.ucam.org>
References: <20090419164043.GA32469@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419164043.GA32469@basil.nowhere.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 06:40:43PM +0200, Andi Kleen wrote:

> That looks strange.  The VFS uses noatime in this case, but both
> flags are set. So it's more a cosmetic issue, but still better
> to fix.
> 
> Cc: mjg@redhat.com

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
