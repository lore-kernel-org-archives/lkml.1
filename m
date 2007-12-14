Return-Path: <linux-kernel-owner+w=401wt.eu-S934959AbXLNANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934959AbXLNANZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765724AbXLNANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:13:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764237AbXLNANG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:13:06 -0500
Date: Thu, 13 Dec 2007 19:12:58 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print taint info in more places.
Message-ID: <20071214001258.GE31405@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20071213224927.GA18639@redhat.com> <p73y7byfb0h.fsf@bingen.suse.de> <20071213235242.GA12755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213235242.GA12755@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 06:52:42PM -0500, Dave Jones wrote:

 >  > Have you checked how this affects code size? It might be worth it 
 >  > now to do a out of line helper.
 > 
 > 64 bit debug build of the fedora kernel (which should be worse 
 >  case for WARN_ONs etc).
 > 
 >          text     data     bss     dec     hex filename
 > before   3833875  834267  631136 5299278  50dc4e vmlinux
 > after    3837054  834267  631136 5302457  50e8b9 vmlinux
 > 
 > Some of that growth is the addition of the missing KERN_ERR,
 > but yeah, it grows a little bit.

And the out-of-line variant of WARN_ON ends up at ..

   text    data     bss     dec     hex filename
3828632  834267  631136 5294035  50c7d3 vmlinux

	Dave

-- 
http://www.codemonkey.org.uk
