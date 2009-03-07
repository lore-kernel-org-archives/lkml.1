Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZCGTM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZCGTM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 14:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCGTMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 14:12:18 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:4364 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZCGTMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 14:12:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w5BJI57xDNcDQVn5faYX/9QEyoAcDuxR2e6NLsXvdwMFSqhVB99ukSfjRvJDB+AFfC
         DtGI80uoyqwuXtlKSQEtCZPoKXpbwp4g6oNLLvWb0RdYbV61oBm4Z1sdFiR/tteSwsoP
         YG6bl++elWwARqTXOdk7IPX2QBvGhSdZ2LNuQ=
Date: Sat, 7 Mar 2009 11:12:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Paul Collins <paul@burly.ondioline.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hid/apple: add module parameter to swap Command
	and Option keys
Message-ID: <20090307191159.GA3355@dtor-d630.eng.vmware.com>
References: <49B19FF3.2000605@gmail.com> <1236398835-8211-1-git-send-email-paul@burly.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236398835-8211-1-git-send-email-paul@burly.ondioline.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sat, Mar 07, 2009 at 05:07:14PM +1300, Paul Collins wrote:
> Apple keyboards have the Command keys (a.k.a. the Apple or "waffle" key)
> in the positions normally occupied on PC keyboards by the Alt/AltGr keys,
> and the Option or Alt keys in the position occupied by the so-called
> Windows keys.  Folks who have been using PC-type computers for too long
> generally have insurmountable muscle memory in this regard.
> 
> This patch adds a module parameter, defaulting to off, that swaps these keys.
> 
> The same effect can also be achieved by changing the console and X
> keymaps, but this approach does not scale.  For example, I don't want to
> have to learn how to reconfigure Wayland's keymaps when the future
> arrives and we all start using it, and there may be applications I don't
> know about that also read keyboard events directly.
> 

We have a mechanism to alter in-kernel "scancode" to mapping from
userspace by issuing EVIOCSKEYCODE ioctl and there are a few utilities
written, in addition to HAL using it. So the best way I think is to
simly add an optional HAL policy.

-- 
Dmitry
