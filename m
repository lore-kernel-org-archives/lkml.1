Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYGFMWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYGFMWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 08:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYGFMV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 08:21:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50510 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbYGFMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 08:21:55 -0400
Date: Sun, 6 Jul 2008 08:20:58 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH] fix potential latency issues in JBD's journal code
Message-ID: <20080706122058.GA26084@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <20080704192929.2c4dd4ca@infradead.org> <20080706041502.GB21990@mit.edu> <20080705223021.02735dc0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080705223021.02735dc0@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 10:30:21PM -0700, Arjan van de Ven wrote:
> it's debatable. Because this submit-bh() will sometimes block... it
> wouldn't get IO started for that case. I think this is where I'd like
> Jens to say what he thinks the rules are; clearly the elevator needs to
> treat all of these guys as sync, but maybe the plugging should be ..
> flexible.

Stupid idea.... maybe the unplugging should be done on the wait side?
Has this been considered already?

						- Ted
