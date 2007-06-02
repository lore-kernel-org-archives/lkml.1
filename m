Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXFBCYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXFBCYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXFBCY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:24:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:37337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbXFBCY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:24:26 -0400
From: Neil Brown <neilb@suse.de>
To: Brad Langhorst <brad@langhorst.com>
Date: Sat, 2 Jun 2007 12:24:02 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18016.54466.838932.490284@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: first one disk drops our of raid, then the other - I/O error on
	same sector. raid bug?
In-Reply-To: message from Brad Langhorst on Friday June 1
References: <1180744988.6830.183.camel@upup>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday June 1, brad@langhorst.com wrote:
> This is a debian stable system in production. Kernel 2.6.18.
> I upgraded the kernel from 2.6.8 to 2.6.18 about 2 weeks ago and saw no
> problems until today.
> 
> 
> May 30 12:58:00 bitc kernel: (scsi0:A:1:0): Unexpected busfree in
> Command phase

This error is not indicative of drive problems, but rather of
buss/controller problems.

The fact that identical problems hit both devices support this.  I
would suggest that you check all cable connections and re-seat the
SCSI card (if it is a separate card).  If the problem persists, look
at replacing hardware.

NeilBrown
