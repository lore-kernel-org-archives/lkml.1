Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYBSPOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYBSPOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYBSPOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:14:00 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:38272 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYBSPN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:13:59 -0500
Date: Tue, 19 Feb 2008 16:13:55 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 07/13] Initialize per cpu lowcores on cpu hotplug.
Message-ID: <20080219151355.GA24547@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20080219144047.587547541@de.ibm.com> <20080219144504.392301782@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080219144504.392301782@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 03:40:54PM +0100, Martin Schwidefsky wrote:
> +	/*
> +	 * Only need to copy the first 512 bytes from address 0. But since
> +	 * the compiler emits a warning if src == NULL for memcpy use copy_page
> +	 * instead. Copies more than needed but this code is not performance
> +	 * critical.
> +	 */
> +	copy_page(lowcore, &S390_lowcore);

Boah, workaround alert. Why do you not fix the compiler?

Bastian

-- 
We fight only when there is no other choice.  We prefer the ways of
peaceful contact.
		-- Kirk, "Spectre of the Gun", stardate 4385.3
