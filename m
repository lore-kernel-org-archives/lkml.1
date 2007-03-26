Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXCZWTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXCZWTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932713AbXCZWTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:19:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbXCZWTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:19:33 -0400
Date: Mon, 26 Mar 2007 15:17:31 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-Id: <20070326151731.53cc080b.zaitcev@redhat.com>
In-Reply-To: <20070325072733.GA10257@cvg>
References: <20070325072733.GA10257@cvg>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 11:27:33 +0400, Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch adds checking of driver registration status
> and if it fails release allocated resources.

> +	if (status_queue) {
> +		destroy_workqueue(status_queue);
> +		status_queue = NULL;
> +	}
> +	if (command_queue) {
> +		destroy_workqueue(command_queue);
> +		command_queue = NULL;
> +	}
> +	if (respond_queue) {
> +		destroy_workqueue(respond_queue);
> +		respond_queue = NULL;
> +	}
> +	return result;

I hate this style with passion, but I don't have cycles to argue.
So, whatever works for you and Greg is fine with me.

-- Pete
