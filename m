Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYFDHU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYFDHU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYFDHUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:20:50 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48976 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140AbYFDHUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:20:49 -0400
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, menage@google.com, xemul@openvz.org
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
In-Reply-To: Your message of "Wed, 4 Jun 2008 14:01:53 +0900"
	<20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Cue version 0.8 (080521-1813/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080604072048.38CF85A0C@siro.lan>
Date: Wed,  4 Jun 2008 16:20:48 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  ssize_t res_counter_write(struct res_counter *counter, int member,
> -		const char __user *buf, size_t nbytes, loff_t *pos,
> -		int (*write_strategy)(char *buf, unsigned long long *val));
> +	const char __user *buf, size_t nbytes, loff_t *pos,
> +        int (*write_strategy)(char *buf, unsigned long long *val),
> +	int (*set_strategy)(struct res_counter *res, unsigned long long val,
> +			    int what),

this comma seems surplus.

> +	);

> +int res_counter_return_resource(struct res_counter *child,
> +				unsigned long long val,
> +	int (*callback)(struct res_counter *res, unsigned long long val),
> +	int retry)
> +{

> +		callback(parent, val);

s/parent/child/

YAMAMOTO Takashi
