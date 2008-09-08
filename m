Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYIHOAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYIHOAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYIHOAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:00:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53924 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYIHOAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:00:42 -0400
Date: Mon, 8 Sep 2008 16:04:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tony Vroon <tony@vroon.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
Message-ID: <20080908140417.GJ26079@one.firstfloor.org>
References: <1220754742.8530.12.camel@localhost> <87abeivrdf.fsf@basil.nowhere.org> <1220876559.27320.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220876559.27320.2.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 01:22:39PM +0100, Tony Vroon wrote:
> On Mon, 2008-09-08 at 12:55 +0200, Andi Kleen wrote:
> > It unfortunately turns out that mcelog logging is a tricky
> > psychological problem. How should the warning above have
> > looked like so that you would not have required "peer insight"
> > and actually just contacted your hardware vendor? 
> 
> Indication of the faulty part, so I know whether to contact AMD or Tyan.
> Without a clear idea of which it could quickly turn into an infinite
> redirect loop between the two.

Ok so you wanted linux-kernel to diagnose your hardware for you?

For DIMMs you can get that with --dmi if you run the latest mcelog
and if it's a memory problem. 

Unfortunately the BIOS vendors in their wisdom often deliver incorrect
DMI tables, so the information is not always very useful.
 
-Andi
-- 
ak@linux.intel.com

