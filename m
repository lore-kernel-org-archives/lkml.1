Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0BHTs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:48:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59703 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab0BHTsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:48:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Avi Kivity <avi@redhat.com>
Subject: Re: kernel NULL pointer dereference/ kvm subsystem
Date: Mon, 8 Feb 2010 20:49:35 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Don Dupuis <dondster@gmail.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <632b79000910060738l5ed0dd6ch60b4569d87d2ef0e@mail.gmail.com> <20100208172931.GA5315@amt.cnet> <4B70616C.9040901@redhat.com>
In-Reply-To: <4B70616C.9040901@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002082049.35919.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010, Avi Kivity wrote:
> On 02/08/2010 07:29 PM, Marcelo Tosatti wrote:
> > On Tue, Oct 06, 2009 at 09:38:05AM -0500, Don Dupuis wrote:
> >    
> >> Kernel 2.6.31.2
> >> x86 64bit
> >>
> >> Running numerous kvm linux guests and noticed this oops in messages
> >> file. This didn't occur in 2.6.30.6
> >>
> >> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> >> IP: [<ffffffffa01de29f>] kpit_elapsed+0x30/0x60 [kvm]
> >>      
> > Fixed by ace1546487a0fe4634e3251067f8a32cb2cdc099.
> >
> > Greg, can you please cherry pick to 2.6.31.stable?
> >    
> 
> It's already in, 2.6.31.6 (and I think 31.y is dead).
> 
> Rafael, this is #14376.

Thanks, closing.

Rafael
