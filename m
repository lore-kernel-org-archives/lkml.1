Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYCPXjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYCPXjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYCPXja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:39:30 -0400
Received: from phunq.net ([64.81.85.152]:33137 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752965AbYCPXj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:39:29 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 15:39:11 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803161536.20128.phillips@phunq.net> <20080316224633.140a5c99@core>
In-Reply-To: <20080316224633.140a5c99@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161639.12555.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008 15:46, Alan Cox wrote:
> > Hostility does not equate to accuracy.  Galileo comes to mind.
> 
> I see no attempt to even discuss the use of two sets
> of physical storage to maintain coherent snapshots, just comments about
> hostility. That's a fairly poor way to repay people who spend a lot of
> time working with enterprise customers and are interested in solutions
> using things like giant ramdisks and are putting in time to discuss
> alternative ways of achieving the desired result.

You did not explain how your proposal will avoid dropping the transaction
throughput down to disk speed, whereas I have explained how my existing
design can be made to achieve enterprise-grade data safety.

As far as I can see, there is no way to do what you propose without
losing a couple of orders of magnitude of transaction response time
under normal running conditions.  If you can see a method that I cannot,
then I am all ears.  Until then... I just loved the earlier post to the
thread:

  "It is not the best way to travel faster than light.  It is just
  the only way".

I do not think you have set out to solve the same problem I have, which
is to attain the highest possible transaction throughput with enterprise
scale reliability.  If you would like to take my code and modify it to
work just as you wish it, then of course you are more than welcome.

Daniel
