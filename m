Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYH2Kiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYH2Kiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYH2Kiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:38:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:62649 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYH2Kip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:38:45 -0400
Subject: Re: [PATCH] fs/ubifs: Use an IS_ERR test rather than a NULL test
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Julien Brunel <brunel@diku.dk>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <200808291108.32958.brunel@diku.dk>
References: <200808291108.32958.brunel@diku.dk>
Content-Type: text/plain; charset=utf-8
Date: Fri, 29 Aug 2008 13:35:14 +0300
Message-Id: <1220006114.4036.16.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Aug 2008 10:38:34.0768 (UTC) FILETIME=[63662100:01C909C3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 11:08 +0200, Julien Brunel wrote:
> In case of error, the function kthread_create returns an ERR pointer,
> but never returns a NULL pointer. So a NULL test that comes before an
> IS_ERR test should be deleted.
> 
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

Pushed to ubifs-2.6.git, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

