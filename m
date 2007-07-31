Return-Path: <linux-kernel-owner+w=401wt.eu-S1765266AbXGaRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765266AbXGaRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXGaRZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:25:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbXGaRZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:25:16 -0400
Date: Tue, 31 Jul 2007 23:06:52 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Neil Horman <nhorman@tuxdriver.com>
cc: akpm@linux-foundation.org, jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] argv_split: allow argv_split to handle NULL pointer in
 argcp parameter gracefully
In-Reply-To: <20070731164608.GB28333@hmsreliant.homelinux.net>
Message-ID: <alpine.LFD.0.999.0707312303490.28746@enigma.security.iitk.ac.in>
References: <20070731164608.GB28333@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Neil Horman wrote:

> As Jeremy and I had discussed in a previous thread, it would be nice if the
> argv_split library function could gracefully handle a NULL pointer in the argcp
> parameter, so as to allow functions using it that did not care about the value
> of argc to not have to declare a useless variable.  This patch accomplishes
> that.  Tested by me, with successful results.

The patch itself looks simple and straightforward enough, but having done
this, now you'd also want to cleanup the use of the dummy variable in the
callsites you mentioned above, correct? (Unless that's what Jeremy meant
in his reply already)
