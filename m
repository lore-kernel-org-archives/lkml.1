Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbZHUWqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbZHUWqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 18:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbZHUWqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 18:46:13 -0400
Received: from claw.goop.org ([74.207.240.146]:39213 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbZHUWqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 18:46:12 -0400
Message-ID: <4A8F2392.8000101@goop.org>
Date: Fri, 21 Aug 2009 15:45:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Michal Schmidt <mschmidt@redhat.com>
CC: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xenfb: connect to backend before registering fb
References: <20090821124059.17ab93fa@leela>	<20090821150922.72e12d9a@leela>	<20090821151352.1676de18@leela> <20090821154407.6337421b@leela>
In-Reply-To: <20090821154407.6337421b@leela>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/09 06:44, Michal Schmidt wrote:
> As soon as the framebuffer is registered, our methods may be called by the
> kernel. This leads to a crash as xenfb_refresh() gets called before we have
> the irq.
>
> Connect to the backend before registering our framebuffer with the kernel.
>   

Thanks, applied.  Should this be backported to stable?

    J
