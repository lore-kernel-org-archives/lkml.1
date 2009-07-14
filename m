Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZGNPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZGNPSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZGNPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:18:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:53100 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbZGNPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:18:22 -0400
Date: Tue, 14 Jul 2009 17:18:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, gregkh@suse.de, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/hid: Drop NULL test on list_entry result
In-Reply-To: <Pine.LNX.4.64.0907120942070.17416@ask.diku.dk>
Message-ID: <alpine.LNX.2.00.0907141717050.813@wotan.suse.de>
References: <Pine.LNX.4.64.0907120942070.17416@ask.diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009, Julia Lawall wrote:

> diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
> index 95835ea..987abeb 100644
> --- a/drivers/hid/hid-lgff.c
> +++ b/drivers/hid/hid-lgff.c
> @@ -151,11 +151,6 @@ int lgff_init(struct hid_device* hid)
>  
>  	/* Check that the report looks ok */
>  	report = list_entry(report_list->next, struct hid_report, list);
> -	if (!report) {
> -		err_hid("NULL output report");
> -		return -1;
> -	}
> -
>  	field = report->field[0];
>  	if (!field) {
>  		err_hid("NULL field");
> 

Applied, thanks Julia.

-- 
Jiri Kosina
SUSE Labs
