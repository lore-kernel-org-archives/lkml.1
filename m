Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbYBLAAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbYBLAAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYBLAAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:00:36 -0500
Received: from xerxes.tchmachines.com ([208.76.80.175]:33200 "EHLO
	xerxes.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741AbYBLAAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:00:33 -0500
Message-ID: <60949.69.30.58.166.1202774430.squirrel@architechnical.net>
Date: Mon, 11 Feb 2008 19:00:30 -0500 (EST)
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
From: "Pete MacKay" <linux01@architechnical.net>
To: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Cc: liam.girdwood@wolfsonmicro.com
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - xerxes.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - architechnical.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In wm97xx-core.c, should

> +int wm97xx_resume(struct device *dev)

be static?

Also, should

> +		if (wm->ts_use_count) {

have been changed to

> +		if (wm->input_dev->users) {

in this revised revision?

(Oops, that was repetitively redundant. :)


