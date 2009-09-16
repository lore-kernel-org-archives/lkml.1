Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbZIPMQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbZIPMQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbZIPMQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:16:38 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51263 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847AbZIPMQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=QePsPcVeoUCZUZQO7jROKyt+BaGF4VDLXx5YX/Dv3DDC/BvokWt88Cln6HXkqCBEMn
         Y8DreZQMCGI7ZNnOU8nrK805L+bAnN1pvkLslqtuYz8xEUgwiQ4OAVgToBxsb9g2pXPm
         M2CuKc6z+zZJEeSoN54Y62MTV2LhmV5LmGd8g=
MIME-Version: 1.0
In-Reply-To: <20090916120529.GB18050@centrinvest.ru>
References: <1253101347-25038-1-git-send-email-andy.shevchenko@gmail.com>
	 <20090916120529.GB18050@centrinvest.ru>
Date: Wed, 16 Sep 2009 15:16:40 +0300
Message-ID: <5ec8ebd50909160516p18fa428ica75ba94a2a40c27@mail.gmail.com>
Subject: Re: [PATCH] media: video: pwc: Use kernel's simple_strtol()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 3:05 PM, Andrey Panin <pazke@centrinvest.ru> wrote:
>> Change own implementation of atoi() by simple_strtol(x, NULL, 10).
> Why did you keep the wrapper itself then ?
I could change in all places, but it's only tiny inline function.

-- 
With Best Regards,
Andy Shevchenko
