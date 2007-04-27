Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbXD0T2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbXD0T2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbXD0T2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:28:15 -0400
Received: from colin.muc.de ([193.149.48.1]:2159 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155AbXD0T2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:28:13 -0400
Date: 27 Apr 2007 21:28:11 +0200
Date: Fri, 27 Apr 2007 21:28:11 +0200
From: Andi Kleen <ak@muc.de>
To: Tim Hockin <thockin@google.com>
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org, akpm@google.com
Subject: Re: [PATCH] x86_64: dynamic MCE poll interval
Message-ID: <20070427192811.GA37201@muc.de>
References: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com> <cc96a5040704271128t60120aedvd439630b3b80b03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc96a5040704271128t60120aedvd439630b3b80b03@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -		printk(KERN_INFO "Machine check events logged\n");
> +		if ((now - last_print) >= check_interval*HZ) {

Shouldn't this use time_after() to handle wrapping? 

-Andi
