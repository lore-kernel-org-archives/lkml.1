Return-Path: <linux-kernel-owner+w=401wt.eu-S934110AbZHWURo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbZHWURo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 16:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934067AbZHWURn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 16:17:43 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:50923 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbZHWURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 16:17:42 -0400
Date: Sun, 23 Aug 2009 22:15:26 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for v2.6.31-rc7
Message-ID: <20090823201526.GA30461@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20090823213714.11757b14@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090823213714.11757b14@skybase>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 09:37:14PM +0200, Martin Schwidefsky wrote:
> +static void __init set_preferred_console(void)
> +{
> +	if (MACHINE_IS_KVM) {
> +		add_preferred_console("hvc", 0, NULL);
> +		s390_virtio_console_init();
> +		return;
> +	}

Why this early return instead of else if as all options are mutually
exclusive? Also why do you init the virtio console here instead of an
console_initcall?

Bastian

-- 
Four thousand throats may be cut in one night by a running man.
		-- Klingon Soldier, "Day of the Dove", stardate unknown
