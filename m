Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZITFJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZITFJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 01:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZITFJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 01:09:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:60920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZITFJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 01:09:14 -0400
Subject: Re: Current git fails to boot with VT-D enabled due to flood of 
 DMAR errors
From: David Woodhouse <dwmw2@infradead.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB5B395.80400@gmail.com>
References: <4AB5B07B.5090506@gmail.com>
	 <1253421668.6317.83.camel@macbook.infradead.org> <4AB5B395.80400@gmail.com>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 22:09:13 -0700
Message-Id: <1253423353.6317.85.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 22:46 -0600, Robert Hancock wrote:
> 
> Yeah, I just came across that patch. Is that going to get pushed for 
> 2.6.32? It seems like something caused us to start tripping over this
> by default when we didn't before. (Passing intel_iommu=on with
> 2.6.30.5 does cause the same problem.)

Yes, I'll push it in the next day or so. Just waiting for another
last-minute fix to be tested by someone other than me, and then I'll ask
Linus to pull.

> I'll try and report the problem to Asus, obviously something's borked 
> with VT-d in their BIOS currently..

Good luck with that. Their normal response is to say "it boots Windows
so it must be perfect". Despite the fact that Windows doesn't actually
use VT-d. Idiots.

-- 
dwmw2

