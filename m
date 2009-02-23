Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZBWOxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZBWOxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZBWOxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:53:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40632 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbZBWOxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:53:32 -0500
Date: Mon, 23 Feb 2009 14:53:29 +0000
From: Andy Whitcroft <apw@canonical.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl stalls on net/decnet/dn_fib.c
Message-ID: <20090223145329.GF22617@shadowen.org>
References: <499DE5CE.3030700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DE5CE.3030700@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 03:05:50PM -0800, John Daiker wrote:
> Andy,
>
> Was running checkpatch.pl on the entire tree today (because my disk  
> loves to get thrashed like that...)  Found what seems to be a stall/hang  
> while running checkpatch.  I know nothing of the internal workings of  
> checkpatch.pl, but hope that you're able to sniff this one out!
>
> ./scripts/checkpatch.pl --file ./net/decnet/dn_fib.c  --debug values=9  
> types=9 possible=9 attr=9

Hmmm, yes thats broken indeed.  Will have a look at it.

-apw
