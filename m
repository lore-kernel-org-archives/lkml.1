Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbXGKJS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbXGKJS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbXGKJST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:18:19 -0400
Received: from smtp.nokia.com ([131.228.20.173]:45066 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbXGKJSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:18:17 -0400
Subject: Re: [PATCH] UBI: cleanup usage of try_module_get
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <1184141505.4608.29.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184141505.4608.29.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=utf-8
Date: Wed, 11 Jul 2007 12:17:51 +0300
Message-Id: <1184145471.3531.88.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Jul 2007 09:17:52.0761 (UTC) FILETIME=[5BE83E90:01C7C39C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 17:11 +0900, Fernando Luis Vázquez Cao wrote:
> The use of try_module_get(THIS_MODULE) in ubi_get_device_info does not
> offer real protection against unexpected driver unloads, since we could
> be preempted before try_modules_get gets executed. It is the caller who
> should manipulate the refcounts. Besides, ubi_get_device_info is an
> exported symbol which guarantees protection when accessed through
> symbol_get.

Yeah, looks fair, committed to UBI git, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

