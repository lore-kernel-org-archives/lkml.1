Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbXCHE30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbXCHE30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXCHE30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:29:26 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37209 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbXCHE3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:29:25 -0500
Date: Thu, 8 Mar 2007 09:59:08 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 11/20] x86_64: wakeup.S misc cleanups
Message-ID: <20070308042908.GD6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <20070307071320.GL23412@in.ibm.com> <20070307224157.GD5956@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307224157.GD5956@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:41:57PM +0100, Pavel Machek wrote:
> Hi!
> 
> > +	movw	$0x0e00 + 'i', %ds:(0xb8012)
> > +	movb	$0xa8, %al	;  outb %al, $0x80;
> > +
> 
> > -	movw	$0x0e00 + 'i', %ds:(0xb8012)
> > -	movb	$0xa8, %al	;  outb %al, $0x80; 	
> 
> Outbs were my debugging hacks, perhaps you can simply remove them at
> this point? Not sure how useful "Linux" debug print is, it can
> probably be removed, too.
> 

Hi Pavel,

I found these debugging hacks useful while debugging some problem with 
my changes in this code. It helps to find out till what poing code flow
as reached in this assembly code. So I think its not a bad idea to let
this piece code be there.

Thanks
Vivek
