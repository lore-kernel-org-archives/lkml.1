Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYCPUtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYCPUtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 16:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYCPUtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 16:49:00 -0400
Received: from phunq.net ([64.81.85.152]:49674 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752353AbYCPUtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 16:49:00 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 12:48:47 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803151417.13899.phillips@phunq.net> <47DCB347.2060706@davidnewall.com>
In-Reply-To: <47DCB347.2060706@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161348.48561.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 22:42, David Newall wrote:
> Daniel Phillips wrote:
> > That is why I keep recommending that a ramback setup be replicated or
> > mirrored, which people in this thread keep glossing over.  When
> > replicated or mirrored, you still get the microsecond-level transaction
> > times, and you get the safety too.
> 
> Do you mean it should be replicated with a second ramback?  That would
> be pretty pointless, since all failure modes would affect both.  It's
> not like one ramback will survive a crash when the other doesn't.

A second machine running a second ramback, on a second UPS pair.
I thought that was obvious.

Daniel
