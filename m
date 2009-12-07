Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbZLGRgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbZLGRgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935482AbZLGRgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:36:44 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53632 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935467AbZLGRgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vf/+vGcDWM1eWM4oKb0bvohA3lyLq+czaj9jviE0X5Bltph6F/57JhrOnLyzwef71G
         wW1/Ub0xmaeANYcsv/Boi50zBmB2HH9IeKrsVrIIQfx6TYzF1fs7W3oUBo1ytTUS5U2Q
         jmbMQExj5Zerr0H/yQ75IOXskZY0lQ00deLQw=
Date: Mon, 7 Dec 2009 09:36:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: input tree build failure
Message-ID: <20091207173640.GA998@core.coreip.homeip.net>
References: <20091207200344.01323cb5.sfr@canb.auug.org.au> <4B1D2C80.4060202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D2C80.4060202@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 08:25:36AM -0800, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi Dmitry,
> > 
> > Today's linux-next build (powerpc allyesconfig) failed like this:
> > 
> > drivers/input/sparse-keymap.c:101: error: __ksymtab_sparse_keymap_setkeycode causes a section type conflict
> > 
> > Caused by commit a2dd9f7ceeb28f495587834aa5778c721611d61b ("Input: add
> > generic support for sparse keymaps").
> > 
> > static functions should not given to EXPORT_SYMBOL().
> > 
> > I have reverted that commit for today.
> 
> (DT:) Is that what causes wistron_btns builds to fail also?
> 

Umm... Wistron and dm355evm_keys now using sparse keymap library so if
it is missing they would fail to compile.

I removed the stray EXPORT_SYMBOL(), shold be good now.

-- 
Dmitry
