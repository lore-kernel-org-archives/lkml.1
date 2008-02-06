Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbYBFL4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbYBFL4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbYBFL4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:56:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:11036 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356AbYBFL4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ANMMwcznMJX/agpemkaMVl7yRcodInF/LNW/dPoT155pOEd5WL+cXD8jZqKX4xn0tpepwb4jusKjxImSGsvETb/32PuY1QIYXUDs+mVpHU3B4bv76eQTNhUxBlA3gEW/PzrhyIcACQafe20DiW/u/bJnEZ8u5PaFEIJcEW1Q7/Q=
Message-ID: <b6a2187b0802060356r19e59e67lfa572939545872e@mail.gmail.com>
Date: Wed, 6 Feb 2008 19:56:04 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: where is the capset kernel module?
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802061225240.23855@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com>
	 <b6a2187b0802060243u3d8187b8v878dddf9eb4d3cb0@mail.gmail.com>
	 <Pine.LNX.4.64.0802061225240.23855@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 2008 7:40 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:

> >warning: `named' uses 32-bit capabilities (legacy support in use)
> Yes it is a really interesting case I have seen before,
> but did not bother to investigate.
> CONFIG_SECURITY=y
> CONFIG_SECURITY_CAPABILITIES=m or y

Tried, but didn't help.

Menuconfig can't select these as modules. So may be that's they need
to be make modular.

     [*] Enable different security models
     [*]   Socket and Networking Security Hooks (NEW)
     [*]   Default Linux Capabilities (NEW)
     [*] File POSIX Capabilities (EXPERIMENTAL)
     [ ] Root Plug Support (NEW)


Thanks,
Jeff.
