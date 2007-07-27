Return-Path: <linux-kernel-owner+w=401wt.eu-S934843AbXG0J7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843AbXG0J7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935212AbXG0J7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:59:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55538 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935000AbXG0J7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:59:07 -0400
Date: Fri, 27 Jul 2007 10:59:05 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, rmk@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/68] 0 -> NULL, for arch/arm
Message-ID: <20070727095905.GU27237@ftp.linux.org.uk>
References: <200707270944.LAA17082@ifs.emn.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707270944.LAA17082@ifs.emn.fr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 11:44:07AM +0200, Yoann Padioleau wrote:
>  		buf = alloc_safe_buffer(device_info, ptr, size, dir);
> -		if (buf == 0) {
> +		if (buf == NULL) {

		if (!buf)
surely...
