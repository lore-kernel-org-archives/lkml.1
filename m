Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZCZH0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZCZH0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZCZHZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:25:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:56562 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZCZHZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:25:54 -0400
Message-ID: <49CB2E20.5030202@kernel.org>
Date: Thu, 26 Mar 2009 16:26:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 07/14] ide-cd: clear sense buffer before issuing	request
 sense
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-8-git-send-email-tj@kernel.org> <20090326072044.GA32155@liondog.tnic>
In-Reply-To: <20090326072044.GA32155@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 26 Mar 2009 07:25:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Borislav Petkov wrote:
> Hmm, not quite. If its info->sense_data, then 18 is not correct. Rather,
> sizeof(struct request_sense) would be more likely the proper length. So,
> actually, it would be more like:
> 
> unsigned sense_len = 18;
> 
> if (sense == NULL) {
> 	sense = &info->sense_data;
> 	sense_len = sizeof(struct request_sense);
> }
> 
> memset(sense, 0, sense_len);

Okay, will update as such.  Thanks.

-- 
tejun
