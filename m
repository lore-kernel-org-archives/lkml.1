Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXH1RNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXH1RNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXH1RNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:13:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXH1RNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:13:32 -0400
Date: Tue, 28 Aug 2007 18:13:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
Message-ID: <20070828171330.GD29343@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
References: <2713029743177393055@pripojeni.net> <280951420471148977@pripojeni.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <280951420471148977@pripojeni.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 12:01:30PM -0400, Jiri Slaby wrote:
> +config ATH5K_AR5210
> +	bool "Support AR5210"
> +	depends on ATH5K
> +	default y
> +
> +config ATH5K_AR5211
> +	bool "Support AR5211"
> +	depends on ATH5K
> +	default y
> +
> +config ATH5K_AR5212
> +	bool "Support AR5212"
> +	depends on ATH5K
> +	default y

Please don't add more default statements.

Also this whole patch seems rather pointless.  It saves only
very little and turns the driver into a complete ifdef maze.
