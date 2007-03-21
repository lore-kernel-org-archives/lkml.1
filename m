Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbXCUX4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbXCUX4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934083AbXCUX4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:56:46 -0400
Received: from saeurebad.de ([85.214.36.134]:39459 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932AbXCUX4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:56:46 -0400
Date: Thu, 22 Mar 2007 00:56:08 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: roland <devzero@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - fix compile warning: `found' might be used uninitialized in this function
Message-ID: <20070321235607.GA10998@localhost>
Mail-Followup-To: roland <devzero@web.de>,
	linux-kernel@vger.kernel.org
References: <04bf01c76c13$5f25ce00$eeeea8c0@aldipc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04bf01c76c13$5f25ce00$eeeea8c0@aldipc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 22, 2007 at 12:48:05AM +0100, roland wrote:
> fs/block_dev.c: In function `bd_claim_by_kobject':
> fs/block_dev.c:953: warning: `found' might be used uninitialized in this 
> function

found actually _is_ used uninitialized if the call to bd_claim() returns
anything but 0.  Thank you!

=Hannes
