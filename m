Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbYF0Oob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbYF0Oob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYF0OoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:44:21 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:56118 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYF0OoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:44:21 -0400
Date: Fri, 27 Jun 2008 16:43:30 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/20] mm: generic show_mem()
Message-ID: <20080627144329.GA7634@osiris.ibm.com>
References: <20080627115349.743368154@saeurebad.de> <20080627120048.059732179@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627120048.059732179@saeurebad.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_HAVE_GENERIC_SHOW_MEM
> +void show_mem(void)
> +{
> +	pg_data_t *pgdat;
> +	int total = 0, reserved = 0, shared = 0, nonshared = 0, highmem = 0;

All of these should be unsigned long. Might overflow on very large
configurations otherwise.
