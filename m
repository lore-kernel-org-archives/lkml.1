Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZJEQWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZJEQWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZJEQWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:22:36 -0400
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:55572 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753746AbZJEQWf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:22:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=U4xqKnaIkJhm9FEIo5r+aliTdXWV48oU0cL3vC3OJi1T7Jsnne8yxPGegjnSF84fJc1ZaKyrW2e7K02M0rXpm6sgq8RdIfA1L+HOioTCksf6E9qKyxrg1M4veq4VkEKH;
Date: Mon, 5 Oct 2009 09:21:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [resend] i915: high power consumption after suspend/resume
Message-ID: <20091005092148.4341d9ab@jbarnes-g45>
In-Reply-To: <cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	<cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Oct 2009 12:50:01 -0400
Andrew Lutomirski <luto@mit.edu> wrote:

> [resend b/c the intel-gfx list doesn't allow non-member posting]
> 
> Hi-
> 
> First, thanks for all the great work on i915's power saving features
> -- power consumption on my laptop (Lenovo X200s) is now almost as low
> on Linux as on Windows.
> 
> After a suspend/resume cycle, though, my power consumption usually
> goes up by over a watt.  I think this is due to i915, because of an
> experiment I did:
> 
> 1. Boot with modesetting off into single user mode.
> 2. Suspend and resume
> 3. Reload i915 with modesetting on.  Power consumption is low.
> 4. Suspend and resume.  Power consumption is high.
> 5. Unbind and rebind i915.  Power consumption is high.
> 6. Suspend.  System hangs (seperate bug, I guess).
> 
> I get similar results if I boot single user with modesetting on: power
> consumption is low, becomes high after suspend/resume, and goes low
> again after rebinding i915.
> 
> This is on 2.6.32-rc1 + a little (i.e. 84d88d5d4e from Linus' tree
> plus an ext4 fix).  I'm having trouble reproducing any of this on
> 2.6.31.

I probably need to save/restore some more of the power saving state
across suspend/resume...  Can you file a bug for this at
bugs.freedesktop.org so it doesn't get lost?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
