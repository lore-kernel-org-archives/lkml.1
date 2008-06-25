Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYFYPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYFYPhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYFYPhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:37:40 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:59672 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYFYPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:37:39 -0400
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 11:37:39 EDT
Date: Wed, 25 Jun 2008 17:15:44 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 07/21] Cleanup sclp printk messages.
Message-ID: <20080625151544.GA12945@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <20080625143459.100139455@de.ibm.com> <20080625143613.141370129@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080625143613.141370129@de.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 04:35:06PM +0200, Martin Schwidefsky wrote:
> +	if (finished_sccb != (u32) (addr_t) sclp_init_sccb)
> +		panic("sclp: unsolicited interrupt for buffer at 0x%x\n",
> +		      finished_sccb);

Does that really need to be a panic?

Bastian

-- 
Extreme feminine beauty is always disturbing.
		-- Spock, "The Cloud Minders", stardate 5818.4
