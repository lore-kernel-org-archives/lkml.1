Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXCRT4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXCRT4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbXCRT4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:56:04 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:43293 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933069AbXCRT4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:56:01 -0400
X-Greylist: delayed 2586 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Mar 2007 15:56:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=GSS28wwlWJ1tPom4PgqSZXkfEXt1CqA8G2xs2t++SfiEjYGfBYVti1pMChocyAJfp7eNFwsdecumwdMjwtFFGF2llnRySoR2aYmSf2IUtazWb41lphCVyEEm774F7jY1+kXx9vrcyphVi0gHgHRhoh93WkruVpbAAagLASnvpCg=;
Date: Sun, 18 Mar 2007 22:55:58 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318195558.GA27004@ms2.inr.ac.ru>
References: <20070318155532.GG7958@mellanox.co.il> <20070318191238.GA20518@ms2.inr.ac.ru> <20070318194638.GA11078@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318194638.GA11078@mellanox.co.il>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Hmm. Something I don't understand: does the code
> in question not run on *each* device unregister?

It does.


> Why do I only see this under stress?

You should have some referenced destination entries to trigger bad path.
This should happen not only under stress.

F.e. just try to ssh to something via this device. And unregister it.
Seems, the crash is inevitable. If you do not see crash, I will be puzzled.

Alexey
