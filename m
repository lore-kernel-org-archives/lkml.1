Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0BWTJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:09:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:39100 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab0BWTJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:09:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ajUtZCe3caLmSd/+ei6fHohWbPGr7SDdlbKQZRkZO4BD56QXB9YWnhAn8vpR7bMiZM
         jt+WQkmaneFCDPsJq7KwrYkfqvsZzn2tEHDrDompufNngYj1bw/RdINye0Ut8Y5GKEfT
         ZMdRHd2ZKJeF9rI3blRkXk6odg3ITYw1+zYXE=
MIME-Version: 1.0
In-Reply-To: <1266788710-32162-1-git-send-email-andy.shevchenko@gmail.com>
References: <1266788710-32162-1-git-send-email-andy.shevchenko@gmail.com>
Date: Tue, 23 Feb 2010 21:09:47 +0200
Message-ID: <5ec8ebd51002231109u3ed2049ew99a42ab3593cf933@mail.gmail.com>
Subject: Re: [PATCH] drivers: isdn: remove custom strtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
       Karsten Keil <isdn@linux-pingi.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 11:45 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Karsten Keil <isdn@linux-pingi.de>
Please, discard it. It has a bit broken logic when the argument is like '0'.
I have prepared version, which uses strict_* method as well.

-- 
With Best Regards,
Andy Shevchenko
