Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYLPVSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYLPVSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYLPVS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:18:27 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36084 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752308AbYLPVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:18:26 -0500
Date: Tue, 16 Dec 2008 21:18:24 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: Kernel function documentation question
Message-ID: <20081216211824.GG12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Documentation/kernel-doc-nano-HOWTO.txt says that functions
should be documented as so:

/**
 * foobar() - short function description of foobar

I notice there are a number of places that ommit the () off the
foobar, for example:

include/linux/skbuff.h, line 461:

/**
 *	skb_get - reference buffer
 *	@skb: buffer to reference

where skb_get does not have ()s.

As a note, it seems the default debian emacs does not colour the
function name unless it ends ().

Also, is there any policy on tabs vs a single space for indenting
these comments?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
