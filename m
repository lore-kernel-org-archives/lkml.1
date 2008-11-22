Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYKVTnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYKVTnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYKVTnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:43:20 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:63492 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYKVTnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CQMccuj7PuhZz2/PK51LPfaU/UXz4cCK7XdJ7oj2aiACIE7Qdx2q9751gbfxv98Gg9
         pwVp8Y17D9Rp8WN+5WLJdtesAblNFAl66NnknbkncHqPB59yh3o6zZqMdrm/rmboH7jM
         ene6CX7BnNksrx7fCiuYZyAOEDJlByUQ7hevo=
Message-ID: <9929d2390811221143n66f3f09bu3801919a54263589@mail.gmail.com>
Date: Sat, 22 Nov 2008 11:43:17 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 14/32] ixgbe section fixes
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, netdev <netdev@vger.kernel.org>
In-Reply-To: <E1L3wOM-0006Ti-Jt@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1L3wOM-0006Ti-Jt@ZenIV.linux.org.uk>
X-Google-Sender-Auth: 605b367cb73624ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 9:35 AM, Al Viro <viro@ftp.linux.org.uk> wrote:
>
> ixgbe_init_interrupt_scheme() is called from ixgbe_resume().  Build that
> with CONFIG_PM and without CONFIG_HOTPLUG and you've got a problem.
> Several helpers called by it also are misannotated __devinit.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/ixgbe/ixgbe_main.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>

Adding Netdev...

Patch does not apply to latest net-next-2.6 tree because half of the
requested changes are already applied to the driver in an earlier
commit.

Please re-test with
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
if possible.

-- 
Cheers,
Jeff
