Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbXJ1QSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbXJ1QSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXJ1QSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:18:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49326 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXJ1QSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:18:46 -0400
Date: Sun, 28 Oct 2007 17:18:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roel Kluin <12o3l@tiscali.nl>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Debugging activated during runtime
In-Reply-To: <4724B3BD.1010509@tiscali.nl>
Message-ID: <Pine.LNX.4.64.0710281717290.30465@fbirervta.pbzchgretzou.qr>
References: <4724A783.9050400@tiscali.nl> <Pine.LNX.4.64.0710281618520.30465@fbirervta.pbzchgretzou.qr>
 <4724B3BD.1010509@tiscali.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28 2007 17:07, Roel Kluin wrote:
>Jan Engelhardt wrote:
>> On Oct 28 2007 16:15, Roel Kluin wrote:
>>> Wouldn't it be nice to be able to specify upon loading, or during runtime
>>> to modules whether debug messages should be printed?
>> 
>> modprobe ark3116 debug=1
>> 
>> Nothing new.
>
>Ok, thanks and sorry, I didn't know that.

Loading debug info at runtime is more complex, and I doubt it is worth
the time. If writing a module, carefully consider when to print what.
When pr_*() comes in, this might be a bit relaxed.

>>> - A module could be loaded after an unexpected conditions (e.g. after a BUG_ON).
>> 
>> After a BUG_ON, you are probably next to a panic.
>
>Not always, it appears.
>

But anything can happen. It might end in a panic. Or it might eat your data.
