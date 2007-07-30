Return-Path: <linux-kernel-owner+w=401wt.eu-S939379AbXG3Jju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939379AbXG3Jju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939270AbXG3Jjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:39:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33129 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939234AbXG3Jjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:39:35 -0400
Subject: Re: [PATCH -rt 7/9] introduce PICK_FUNCTION
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20070730024720.690642602@mvista.com>
References: <20070730024534.369897977@mvista.com>
	 <20070730024720.690642602@mvista.com>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 11:39:28 +0200
Message-Id: <1185788368.7197.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 19:45 -0700, Daniel Walker wrote:

> +#undef TYPE_EQUAL
> +#define TYPE_EQUAL(var, type) \
> +		__builtin_types_compatible_p(typeof(var), type *)
> +

If you're going to touch this code, could you perhaps change TYPE_EQUAL
to do as it says and read like so:

	__builtin_types_compatible_p(typeof(var), type)



