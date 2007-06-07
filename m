Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbXFGHve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbXFGHve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXFGHv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:51:27 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:25200 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753478AbXFGHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:51:26 -0400
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, jbaron@redhat.com, rostedt@goodmis.org,
       billh@gnuppy.monkey.org, mingo@elte.hu, linux-s390@vger.kernel.org
In-Reply-To: <1181165656.7133.23.camel@dix>
References: <1181165656.7133.23.camel@dix>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 09:51:23 +0200
Message-Id: <1181202683.7348.220.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 23:34 +0200, Martin Peschke wrote:

> +struct statistic_info lock_stat_info[_LOCK_STAT_NUMBER] = {
> +	[LOCK_STAT_CONT] = {
> +		.name	  = "contentions",
> +		.x_unit	  = "instruction_pointer",
> +		.y_unit	  = "occurrence",
> +		.defaults = "type=sparse entries=4",
> +		.flags	  = STATISTIC_FLAGS_LABEL,
> +	},
> +	[LOCK_STAT_WAIT_READ] = {
> +		.name	  = "wait_read",
> +		.x_unit	  = "nanoseconds",
> +		.y_unit	  = "occurrence",
> +		.defaults = "type=utilisation",
> +	},
> +	[LOCK_STAT_WAIT_WRITE] = {
> +		.name	  = "wait_write",
> +		.x_unit	  = "nanoseconds",
> +		.y_unit	  = "occurrence",
> +		.defaults = "type=utilisation",
> +	},
> +	[LOCK_STAT_HOLD_READ] = {
> +		.name	  = "hold_read",
> +		.x_unit	  = "nanoseconds",
> +		.y_unit	  = "occurrence",
> +		.defaults = "type=utilisation",
> +	},
> +	[LOCK_STAT_HOLD_WRITE] = {
> +		.name	  = "hold_write",
> +		.x_unit	  = "nanoseconds",
> +		.y_unit	  = "occurrence",
> +		.defaults = "type=utilisation",
>  	}
>  };

You're parsing strings in-kernel to setup data structures?

