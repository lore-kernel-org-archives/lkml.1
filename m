Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYKJO2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYKJO2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYKJO2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:28:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57809 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYKJO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:28:21 -0500
Date: Mon, 10 Nov 2008 08:28:10 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH -v3 1/5] Capabilities: document the order of arguments
	to cap_issubset
Message-ID: <20081110142810.GA11561@us.ibm.com>
References: <20081107151355.9977.47852.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107151355.9977.47852.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> Document the order of arguments for cap_issubset.  It's not instantly clear
> which order the argument should be in.  So give an example.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks, Eric.

-serge

> ---
> 
>  include/linux/capability.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 9d1fe30..9f44150 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -454,6 +454,13 @@ static inline int cap_isclear(const kernel_cap_t a)
>  	return 1;
>  }
> 
> +/*
> + * Check if "a" is a subset of "set".
> + * return 1 if ALL of the capabilities in "a" are also in "set"
> + *	cap_issubset(0101, 1111) will return 1
> + * return 0 if ANY of the capabilities in "a" are not in "set"
> + *	cap_issubset(1111, 0101) will return 0
> + */
>  static inline int cap_issubset(const kernel_cap_t a, const kernel_cap_t set)
>  {
>  	kernel_cap_t dest;
