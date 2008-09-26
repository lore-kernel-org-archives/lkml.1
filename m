Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYIZOuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYIZOuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYIZOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:49:59 -0400
Received: from smtp.nokia.com ([192.100.122.230]:41422 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYIZOt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:49:58 -0400
Subject: Re: [PATCH] drivers/mtd/ubi: Bad IS_ERR test
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Julien Brunel <brunel@diku.dk>
Cc: haver@vnet.ibm.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <200809261527.26007.brunel@diku.dk>
References: <200809261527.26007.brunel@diku.dk>
Content-Type: text/plain; charset=utf-8
Date: Fri, 26 Sep 2008 17:48:48 +0300
Message-Id: <1222440528.5012.19.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Sep 2008 14:48:53.0281 (UTC) FILETIME=[FEB25910:01C91FE6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 15:27 +0200, Julien Brunel wrote:
> In case of error, the function add_volume returns an ERR pointer. The
> result of IS_ERR, which is supposed to be used in a test as it is, is
> here checked to be less than zero, which seems odd. We suggest to
> replace this test by a simple IS_ERR test.

Pushed to ubi-2.6.git, thank you!

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

