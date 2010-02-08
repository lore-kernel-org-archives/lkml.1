Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab0BHRaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:30:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0BHR37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:29:59 -0500
Date: Mon, 8 Feb 2010 15:29:31 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Don Dupuis <dondster@gmail.com>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: kernel NULL pointer dereference/ kvm subsystem
Message-ID: <20100208172931.GA5315@amt.cnet>
References: <632b79000910060738l5ed0dd6ch60b4569d87d2ef0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <632b79000910060738l5ed0dd6ch60b4569d87d2ef0e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 09:38:05AM -0500, Don Dupuis wrote:
> Kernel 2.6.31.2
> x86 64bit
> 
> Running numerous kvm linux guests and noticed this oops in messages
> file. This didn't occur in 2.6.30.6
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> IP: [<ffffffffa01de29f>] kpit_elapsed+0x30/0x60 [kvm]

Fixed by ace1546487a0fe4634e3251067f8a32cb2cdc099. 

Greg, can you please cherry pick to 2.6.31.stable?

TIA

