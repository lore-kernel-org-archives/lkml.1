Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbXE2RVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbXE2RVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXE2RU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:20:58 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:12808 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbXE2RU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=St7xDfbKaKDXZzXu5QEVvroZjo9w/BbwohE/YCG9QG7L57PhLlG97Qtep9XuLcI1vBU6wzJW9Elli88tL8Ca6dIpX5DF/HYe9RjOqgeubXAXxfz4SW1UbxHB7oaUkwnwaNIIjGq19wjNdGLu+7xYJ7octFNjVqZwGyOUSFMsGV4=
Message-ID: <8bd0f97a0705291020p5263b0bco88c556ff8cabf05c@mail.gmail.com>
Date: Tue, 29 May 2007 13:20:52 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 19/20] Blackfin on-chip watchdog driver
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>,
       "Wim Van Sebroeck" <wim@iguana.be>
In-Reply-To: <11803414821370-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11803414753217-git-send-email-bryan.wu@analog.com>
	 <11803414821370-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Bryan Wu <bryan.wu@analog.com> wrote:
> From: Mike Frysinger <michael.frysinger@analog.com>
>
> This patch implements the driver necessary use the Analog Devices
> Blackfin processor's on-chip watchdog controller, supports
> BF53[123]/BF53[467]/BF561.
>
> Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

we probably want to NACK this and wait for me to rip out the timer
bits into a sep clockevents driver

>  drivers/char/watchdog/Kconfig.orig      |  768 +++++++++++++++++++++++++++++++

looks like you got cruft in this patch anyways ...
-mike
