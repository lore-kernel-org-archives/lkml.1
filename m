Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZJEBjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZJEBjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 21:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbZJEBjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 21:39:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44806 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbZJEBjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 21:39:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com, Bryan Donlan <bdonlan@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20091005095121.5F7A.A69D9226@jp.fujitsu.com>
References: <3e8340490910041105p327396e8v39b1a3454c0922bf@mail.gmail.com> <20091005095121.5F7A.A69D9226@jp.fujitsu.com>
Message-Id: <20091005103744.5F83.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  5 Oct 2009 10:38:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The improvement idea is here.
> 
> Changelog
>   - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
>  -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)

Doh, task_lock() is obviously wrong. please forget this.


