Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZKTTQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZKTTQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZKTTQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:16:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59386 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbZKTTQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:16:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RnYHmYPY50r1PeOfhkElVgiKav60OJAZjREmR6kPyQQtjBZF1wv7wKzjBEtHRY4/z2
         kHzmtrKUXdLBD32wi3yiPJazY3jHzrf2RvTEGrBZUANnO5w/fQDaDhf25bEa3qwzKt/P
         rZ0xTGFOZUF0wP+BbgLzL1RBzO5XN+47NoHRc=
MIME-Version: 1.0
In-Reply-To: <20091120.111355.141716974.davem@davemloft.net>
References: <1258725747.3562.5.camel@ht.satnam>
	 <9929d2390911200624mf352c28u55a8b2aee8b52fa3@mail.gmail.com>
	 <20091120.111355.141716974.davem@davemloft.net>
Date: Fri, 20 Nov 2009 11:16:54 -0800
X-Google-Sender-Auth: 615dd16b5e41d605
Message-ID: <9929d2390911201116l562291cbh8e6a557b64fa7ef0@mail.gmail.com>
Subject: Re: [PATCH] ixgbe: move tc variable to CONFIG_IXGBE_DCB
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Miller <davem@davemloft.net>
Cc: jaswinder@kernel.org, yi.zou@intel.com, peter.p.waskiewicz.jr@intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:13, David Miller <davem@davemloft.net> wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Fri, 20 Nov 2009 06:24:21 -0800
>
>> On Fri, Nov 20, 2009 at 06:02, Jaswinder Singh Rajput
>> <jaswinder@kernel.org> wrote:
>>>
>>> tc is required by CONFIG_IXGBE_DCB.
>>> This also fixes compilation warning:
>>>
>>>  drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_tx_is_paused’:
>>>  drivers/net/ixgbe/ixgbe_main.c:245: warning: unused variable ‘tc’
>>>
>>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>  ...
>> I just submitted a patch to fix this.  So NAK.
>
> But his is much cleaner that your's, less ifdefs.  I think we
> should therefore use Jasdinder's version.
>
>

:) That is fine.  The end result is the same.

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

-- 
Cheers,
Jeff
