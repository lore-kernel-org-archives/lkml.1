Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZADCS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZADCS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZADCSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:18:50 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:40905 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZADCSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:18:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=i58eAu42wqVloeM534ud9WSHAVOWPJP6rJSQpboAKl83z+KNB7yOeQrtFzyzU2sO;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sat, 3 Jan 2009 21:18:43 -0500
From: Bill Fink <billfink@mindspring.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling
 broken on big-endian
Message-Id: <20090103211843.d36d252f.billfink@mindspring.com>
In-Reply-To: <495F976C.8030105@s5r6.in-berlin.de>
References: <1229210489.11257.16.camel@brick>
	<4944561D.4010608@s5r6.in-berlin.de>
	<20081213204137.d150645c.billfink@mindspring.com>
	<49446923.5040606@s5r6.in-berlin.de>
	<20081223172300.5bd19846.billfink@mindspring.com>
	<20081225220244.1eacb39d.billfink@mindspring.com>
	<495F976C.8030105@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d72e0b50997696b4ac608b606f7988716350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Jan 2009, Stefan Richter wrote:

> Bill Fink wrote on 2008-12-26:
> > Good news.  I finally got a chance to test the patch on my kernel,
> > and live DV viewing using xine still worked fine.
> 
> Thanks a lot.  If you don't mind, I'll add "Tested-by: Bill Fink
> <billfink@mindspring.com>" to the changelog when I enqueue this for
> Linus, and add a note that it actually worked for you before as well as
> after this patch.

That's fine.  Although I admit to being mystified how it works both
before and after the patch, since the cpu_to_le32() calls that were
added should result in byte swapping on PPC that wasn't being done
before.  I guess that either the code paths involved aren't actually
being triggered by my xine DV viewing, or there's some fortuitous
palindromic setting of bits.

						-Bill
