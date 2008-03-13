Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYCMVac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYCMVac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbYCMVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:30:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240AbYCMVaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:30:11 -0400
Date: Thu, 13 Mar 2008 17:30:00 -0400
From: Rik van Riel <riel@redhat.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, pe1rxq@amsat.org,
       linux-usb@vger.kernel.org, video4linux-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] logical-bitwise & confusion in se401_init() (was:
 logical-bitwise & confusion in se401_init()?)
Message-ID: <20080313173000.5bd1d039@cuia.boston.redhat.com>
In-Reply-To: <47D94D81.5090108@tiscali.nl>
References: <47D47257.9090204@tiscali.nl>
	<20080313120602.6920a621@gaivota>
	<47D94D81.5090108@tiscali.nl>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 16:51:29 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> -	if (!cp[2] && SE401_FORMAT_BAYER) {
> +	if (!cp[2] & SE401_FORMAT_BAYER) {
>  		err("Bayer format not supported!");
>  		return 1;
>  	}

Would it be better to put in some additional parenthesis?

	if (!(cp[2] & SE401_FORMAT_BAYER)) {

-- 
All Rights Reversed
