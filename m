Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZBWPQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZBWPQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZBWPP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:15:59 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60506 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZBWPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:15:58 -0500
Date: Mon, 23 Feb 2009 15:15:55 +0000
From: Andy Whitcroft <apw@canonical.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl stalls on net/decnet/dn_fib.c
Message-ID: <20090223151555.GG22617@shadowen.org>
References: <499DE5CE.3030700@gmail.com> <20090223145329.GF22617@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223145329.GF22617@shadowen.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 02:53:29PM +0000, Andy Whitcroft wrote:
> On Thu, Feb 19, 2009 at 03:05:50PM -0800, John Daiker wrote:
> > Andy,
> >
> > Was running checkpatch.pl on the entire tree today (because my disk  
> > loves to get thrashed like that...)  Found what seems to be a stall/hang  
> > while running checkpatch.  I know nothing of the internal workings of  
> > checkpatch.pl, but hope that you're able to sniff this one out!
> >
> > ./scripts/checkpatch.pl --file ./net/decnet/dn_fib.c  --debug values=9  
> > types=9 possible=9 attr=9
> 
> Hmmm, yes thats broken indeed.  Will have a look at it.

Ok, think I have this one sorted.  Could you test with the version of
checkpatch at this URL:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

Thanks for the report. 

-apw
