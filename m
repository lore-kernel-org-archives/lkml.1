Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYEDPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYEDPDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYEDPDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:03:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:4357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYEDPDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:03:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CTRkHE1QYzq3j3vBHFSrw7w4u6SZS8iBwVi6sTVEE4xQj52HzH73TYUad9V73D+NcOGRBTbKH+FnL/8383qUaDz6EfVL3f8QTmajsD+3w8jNzcvykamhDWkKaTJ88FrKaxhVLH5uGltNB/Ob5WP1ddMhDNVo48RDnaX76YSFUys=
Message-ID: <e2e108260805040802l4b2bb9dfjce898903fe746a1c@mail.gmail.com>
Date: Sun, 4 May 2008 17:02:59 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jay Cliburn" <jacliburn@bellsouth.net>
Subject: Re: Need help debugging memory corruption
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Chris Snook" <csnook@redhat.com>
In-Reply-To: <20080503130951.091392ba@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080503130951.091392ba@osprey.hogchain.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 8:09 PM, Jay Cliburn <jacliburn@bellsouth.net> wrote:
> Can someone with more experience than me please take a look and give me
> some advice or explain what might be happening here?  (What may be
> obvious to you is probably not obvious to me.)

Are you familiar with the kernel command-line option slub_debug=FZPU ?
If this was not yet enabled, recompiling your kernel with
CONFIG_SLUB=y and CONFIG_SLUB_DEBUG=y enabled and specifying
slub_debug=FZPU on the kernel command line will probably provide more
detailed information about the cause of the memory corruption.

Bart.
