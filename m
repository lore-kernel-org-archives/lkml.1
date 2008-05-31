Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYFEWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYFEWQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYFEWQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:16:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYFEWQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:16:23 -0400
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48485BA3.60809@garzik.org>
References: <20080605.foo@pmac.infradead.org>  <48483BA9.1070200@garzik.org>
	 <1212695675.32207.288.camel@pmac.infradead.org>
	 <4848489C.6010903@garzik.org>
	 <1212699190.32207.293.camel@pmac.infradead.org>
	 <48485435.7020308@garzik.org>
	 <1212268943.2534.16.camel@shinybook.infradead.org>
	 <48485BA3.60809@garzik.org>
Content-Type: text/plain
Date: Sat, 31 May 2008 23:15:06 +0100
Message-Id: <1212272106.2534.23.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 17:33 -0400, Jeff Garzik wrote:
> Right.  And now you are creating Yet Another Format, rather than 
> rendering the firmware back into the preferred format:  binary blob.

At least it's simpler than the various formats we have at the moment.

> _If_ you are changing form of current in-tree firmwares at all, there is 
> no excuse not use direct binary blob -- the least common denominator for 
> all relevant operations.

There's plenty of excuses. The fact that we don't have any binary blobs
in the tree is a fairly big hint -- they're not easily processed by the
tools we use (like 'diff').

I'm keen to avoid unnecessary controversy while I convert drivers to
request_firmware(). I don't want to convert the existing ASCII
representations into raw binary blobs right now, because it's not my
primary focus and I don't care enough about it to fight that battle.

If you want to follow up with a patch to remove .ihex files and replace
them with raw binaries -- or better still start posting patches which
convert the drivers I've yet to get to, and just put raw binary blobs
into firmware/ instead of .ihex as I would, then please go ahead. But
please don't be offended if I don't put them in my firmware-2.6.git tree
because I think that'll make it less likely to get merged.

> Storing the firmware in .ihex is just as bad as storing the firmware in 
> source code -- it's a pointless wrapper that makes firmware verification 
> and updates far more difficult than they should be.

But still a lot easier than before I did it. One thing at a time, Jeff.

-- 
dwmw2

