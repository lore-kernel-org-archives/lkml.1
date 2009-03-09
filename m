Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZCIP5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZCIP5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZCIP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:57:37 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:60283 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZCIP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Uj+eZJ6e9h0ryFza7WjuDnYXL9yOBlMm783X7H6lRfhmMyMNPbC49VaAFxA1mM+F5G
         IgpfrYwSWONNaoiF7alP/DQ2phzzUA9mEzgEuZfugwYPr831NmKaxSIzazPg8T7MyfxG
         T+Wlf685t+fXAu5pv1BIyffCTHWn7jTj2qUqI=
Message-ID: <49B53C69.5040805@gmail.com>
Date: Mon, 09 Mar 2009 16:57:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 0/5] WM97xx updates
References: <20090303182402.GA29542@rakim.wolfsonmicro.main>	<20090304091538.GD7394@dtor-d630.eng.vmware.com>	<49AE492F.6020006@atmel.com>	<20090304105358.GA32107@rakim.wolfsonmicro.main>	<49AE65FF.2060309@atmel.com> <20090309164846.75152a9a@hcegtvedt>
In-Reply-To: <20090309164846.75152a9a@hcegtvedt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.3.2009 16:48, Hans-Christian Egtvedt wrote:
> Please see attached patch.

Note that atmel_wm97xx struct still leaks on atmel_wm97xx_probe fail paths.
