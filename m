Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYCQCmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYCQCmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYCQCmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 22:42:16 -0400
Received: from phunq.net ([64.81.85.152]:40784 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752590AbYCQCmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 22:42:15 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 18:42:01 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803161457.04580.phillips@phunq.net> <47DDC9EC.4060208@davidnewall.com>
In-Reply-To: <47DDC9EC.4060208@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161942.01944.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008 18:31, David Newall wrote:
> Daniel Phillips wrote:
> > The UPS provides a guarantee of commit to stable storage.  No amount of
> > FUD will change that.
> 
> What about system crashes?  They guarantee that data will be lost.  I

Not if it is mirrored and replicated.  Also nice if crashes are very
rare, which they are unless you work at it.

> know opinions are divided on the subject of crashes: You say Linux
> doesn't; everybody else says it does.  I side with experience.  (It does.)

I say it does not crash often, to the point where I have not seen it
crash once for any reason I did not create myself (I tend to wait for
the occasional brown bag release to fade away before shifting development  We do get quite a few
reports of less mature systems like hald and usb causing problems, and
not too long ago NFS client was very crash happy.  I did see some of
those myself two years ago, and fixed them.

On the whole, Linux is very reliable.  Very very reliable.  Now mirror
that, replicate it, add in 2 x 2 redundant power supplies backed by
independent UPS units so you can do regular preemptive maintenance on
the batteries, and you have a sweet enterprise transaction processing
system.  All set for a faster than light moon shot :-)

Daniel
