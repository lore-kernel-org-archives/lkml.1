Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZBZTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZBZTu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZBZTuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:50:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:41712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZBZTuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:50:10 -0500
Subject: Re: Linux 2.6.29-rc6
From: David Woodhouse <dwmw2@infradead.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Olsen <dolsen@lnxi.com>, Ryan Jackson <rjackson@lnxi.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49A6F1AC.4090305@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A679E8.1010301@krogh.cc>
	 <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain>
	 <49A6EE17.4070102@krogh.cc>
	 <1235677008.8730.176.camel@macbook.infradead.org>
	 <49A6F1AC.4090305@krogh.cc>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 04:49:57 +0900
Message-Id: <1235677797.8730.177.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 20:46 +0100, Jesper Krogh wrote:
> It is a module.. and it somehow gets auto-loaded on my system. (not 
> listed in /etc/modules).

Oops, we should have disabled that, but it still has a
MODULE_DEVICE_TABLE(). I'll remove that, for a start...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

