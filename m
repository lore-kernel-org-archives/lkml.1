Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYLHJH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYLHJH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYLHJGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:06:39 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:34530 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYLHJGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:06:33 -0500
Subject: Re: [PATCH 1/2] drivers/s390/crypto: Move dereference to after
	IS_ERR test
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Julia Lawall <julia@diku.dk>
Cc: heiko.carstens@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812072314270.7130@ask.diku.dk>
References: <Pine.LNX.4.64.0812072314270.7130@ask.diku.dk>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 08 Dec 2008 10:06:29 +0100
Message-Id: <1228727189.15048.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-07 at 23:14 +0100, Julia Lawall wrote:
> If reply is ERR_PTR(...), then it should not be dereferenced, so I have
> moved the dereference from the declaration to after the IS_ERR test.

Nice finding again. That semantic match tools is really useful.
Thanks, I'll add the patch to my collection.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


