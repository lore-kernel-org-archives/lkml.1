Return-Path: <linux-kernel-owner+w=401wt.eu-S1751358AbYAOKrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbYAOKrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYAOKqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:46:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50010 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYAOKqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:46:51 -0500
Date: Tue, 15 Jan 2008 19:47:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Clifford Wolf <clifford@clifford.at>
Subject: Re: rlim in proc/<pid>/status
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080115100631.GA13394@clifford.at>
References: <20080115100631.GA13394@clifford.at>
Message-Id: <20080115194321.119D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

sound good for me.
a few question please.

> +	for (i=0; i<RLIM_NLIMITS; i++) {
> +		if (rlim_names[i])
> +			buffer += sprintf(buffer, "Rlim%s:\t", rlim_names[i]);
> +		else
> +			buffer += sprintf(buffer, "Rlim%d:\t", i);

this else is really necessary?

> +		if (rlim[i].rlim_cur != ~0)
> +			buffer += sprintf(buffer, "%lu\t", rlim[i].rlim_cur);
> +		else
> +			buffer += sprintf(buffer, "-\t");
> +		if (rlim[i].rlim_max != ~0)
> +			buffer += sprintf(buffer, "%lu\n", rlim[i].rlim_max);
> +		else
> +			buffer += sprintf(buffer, "-\n");

Why do you don't use RLIM_INFINITY?

- kosaki


