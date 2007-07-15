Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbXGOJNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbXGOJNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXGOJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:12:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60410 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbXGOJM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:12:57 -0400
Date: Sun, 15 Jul 2007 10:12:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com
Subject: Re: [RFC 0/3] lro: Generic Large Receive Offload for TCP traffic
Message-ID: <20070715091253.GA15790@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Miller <davem@davemloft.net>, ossthema@de.ibm.com,
	netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	meder@de.ibm.com, tklein@de.ibm.com, stefan.roscher@de.ibm.com
References: <200707111621.24852.ossthema@de.ibm.com> <20070714.235748.02297780.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714.235748.02297780.davem@davemloft.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 11:57:48PM -0700, David Miller wrote:
> only request is to make this thing able to handle ipv6 as
> well even if no current chips could facilitate that yet.

I'm not sure that's a good idea.  If current chips can't handle ipv6
lro there is no way to actually test it and the code will surely bitrot.

