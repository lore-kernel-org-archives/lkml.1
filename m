Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYIEAXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYIEAXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYIEAXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:23:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbYIEAXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:23:37 -0400
Date: Thu, 4 Sep 2008 17:23:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, dbaryshkov@gmail.com
Subject: Re: [PATCH] platform: add new device registration helper
Message-Id: <20080904172323.0dedfd90.akpm@linux-foundation.org>
In-Reply-To: <1220563816-8106-1-git-send-email-dbaryshkov@gmail.com>
References: <1220563816-8106-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also,

On Fri,  5 Sep 2008 01:30:16 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

>  }
>  EXPORT_SYMBOL_GPL(platform_device_register_simple);
>  
> ...
>
> +struct platform_device *platform_device_register_data(

When you start implementing callers, please check whether
platform_device_register_data() should have been exported to modules.

