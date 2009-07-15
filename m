Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbZGOSQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbZGOSQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZGOSQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:16:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39546
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784AbZGOSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:16:03 -0400
Date: Wed, 15 Jul 2009 11:16:06 -0700 (PDT)
Message-Id: <20090715.111606.193724419.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ide-tape: misc stuff
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247671100-8173-1-git-send-email-petkovbb@gmail.com>
References: <1247671100-8173-1-git-send-email-petkovbb@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Wed, 15 Jul 2009 17:18:16 +0200

> here is some ide-tape stuff.
> 
> * 0001: somehow fell through the cracks, DEBUG build fix

This is OK.

> * 0002: mostly code unification

I'm not applying this.  IDE is in deep maintainence mode and
we really need to avoid changes that don't fix real bugs and
have only marginal benefit, like this change.

> * 0003: this one converts ide-tape to the debugging scheme we use with ide-cd
>   and ide-floppy. It adds some debug calls at important places and has proven
>   very helpful when working on bug reports with users. No functional change.

I'm not applying this for the same reason as patch #2.

> * 0004: real bugfix

Ok, did you test this?

Please respin patch #1 and #4 as a two patch set and resubmit.

Thank you.
