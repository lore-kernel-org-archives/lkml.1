Return-Path: <linux-kernel-owner+w=401wt.eu-S1762376AbYCEVXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762376AbYCEVXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760592AbYCEVXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:23:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39051
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758973AbYCEVXN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:23:13 -0500
Date: Wed, 05 Mar 2008 13:23:12 -0800 (PST)
Message-Id: <20080305.132312.55544366.davem@davemloft.net>
To: aurelien@aurel32.net
Cc: hpa@zytor.com, matz@suse.de, Joe.Buck@synopsys.COM,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <47CF07FE.10200@aurel32.net>
References: <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	<47CF0627.2070200@zytor.com>
	<47CF07FE.10200@aurel32.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>
Date: Wed, 05 Mar 2008 21:52:14 +0100

> H. Peter Anvin a écrit :
> > The best would be if this could be controlled by a flag, which we can
> > flip once kernel fixes has been around for long enough.
> 
> I have to agree there. Whatever the decision that gcc will take,
> distributions will reenable the old behaviour for some time for to allow
> upgrades from a previous version.

I don't think this approach is tenable.

If a distribution should ship with a "fixed" kernel and
compiler enabling the new direction flag behavior, any
binary you create on that system will be broken on any
other existing system.

I think we really are stuck with this forever, overwhelming
practice over the past 15 years has dictated to us what the
real ABI is.
