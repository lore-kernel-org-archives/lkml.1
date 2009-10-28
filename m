Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZJ1F3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZJ1F3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbZJ1F3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:29:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44127
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757311AbZJ1F3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:29:31 -0400
Date: Tue, 27 Oct 2009 22:29:55 -0700 (PDT)
Message-Id: <20091027.222955.05560476.davem@davemloft.net>
To: andi@firstfloor.org
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091028043611.GK7744@basil.fritz.box>
References: <87hbtkjkki.fsf@basil.nowhere.org>
	<20091027.203709.27104760.davem@davemloft.net>
	<20091028043611.GK7744@basil.fritz.box>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 28 Oct 2009 05:36:11 +0100

> On Tue, Oct 27, 2009 at 08:37:09PM -0700, David Miller wrote:
>> On sparc64, in order to make debugging easier, we trap any time
>> the kernel does a userspace access to a compat task and any
>> of the upper 32-bits are non-zero.
> 
> Interesting. That definitely means Dave needs a special path.

I wouldn't call it special, the rule is that any userland pointer
has to either go through a syscall argument register or one
of the compat_*() accessor routines :-)
