Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYCMTQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYCMTQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbYCMTO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:14:57 -0400
Received: from phunq.net ([64.81.85.152]:39058 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756190AbYCMTOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:14:54 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 11:14:39 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803122314.18244.phillips@phunq.net> <20080313132211.6af855b3@the-village.bc.nu>
In-Reply-To: <20080313132211.6af855b3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131214.40321.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 06:22, Alan Cox wrote:
> ...Ext3 cannot recover well from massive loss of intermediate
> writes. It isn't a normal failure mode and there isn't sufficient fs
> metadata robustness for this. A log structured backing store would deal
> with that but all you apparently want to do is scream FUD at anyone who
> doesn't agree with you.

Scream is an exaggeration, and FUD only applies to somebody who
consistently overlooks the primary proposition in this design: that the
battery backed power supply, computer hardware and Linux are reliable
enough to entrust your data to them.  I say this is practical, you say
it is impossible, I say FUD.

All you are proposing is that nobody can entrust their data to any
hardware.  Good point.  There is no absolute reliability, only degrees
of it.

Many raid controllers now have battery backed writeback cache, which
is exactly the same reliability proposition as ramback, on a smaller
scale.  Do you refuse to entrust your corporate data to such
controllers?

Daniel
