Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYCMUEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYCMUEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYCMUE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:04:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbYCMUEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:04:25 -0400
Date: Thu, 13 Mar 2008 13:03:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not allow setting of quota limits to too high values
Message-Id: <20080313130355.6a84d0c5.akpm@linux-foundation.org>
In-Reply-To: <20080312172255.GB21395@duck.suse.cz>
References: <20080312172255.GB21395@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH] Do not allow setting of quota limits to too high values

Please put "quota:" at the start of the title to identify the subsystem.  So,

Subject: [PATCH] quota: do not allow setting of quota limits to too high values

would have suited.  Thanks.

On Wed, 12 Mar 2008 18:22:55 +0100
Jan Kara <jack@suse.cz> wrote:

> From: Andrew Perepechko <andrew.perepechko@sun.com>
> 
> We should check whether quota limits set via Q_SETQUOTA are not exceeding
> limits which quota format is able to handle.
> 
> Signed-off-by: Andrew Perepechko <andrew.perepechko@sun.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> ---
>   Andrew, would you please queue it up for inclusion? Thanks.

For 2.6.26, I assume?  I am not able to determine the seriousness of this
problem from the changelog nor from the patch itself.
