Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZEYNuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZEYNuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZEYNu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:50:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:22561 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZEYNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SdBfKIYpeVg3XLmXEaQFFW2wG52IZVZKpSITdizV3E9DoSkiJtakN1didaW7jV0oLO
         qklY7r66RTVXH9qD5rRB4ZJWpBZIsy+7OPBoG21GbLuwo8gltALlzBugC9WAUiCEJcST
         KFvNqK8pZwJKDO/S4PFmknB5LpsizsjA7tUv8=
MIME-Version: 1.0
In-Reply-To: <20090525143603.3a741658@lxorguk.ukuu.org.uk>
References: <dfb262380905250250w2d689b28i25edc3d492b09676@mail.gmail.com>
	 <20090525143603.3a741658@lxorguk.ukuu.org.uk>
Date: Mon, 25 May 2009 16:50:26 +0300
Message-ID: <dfb262380905250650p310d6b69geece0badba8868b0@mail.gmail.com>
Subject: Re: serial device and fsync
From: Ramagudi Naziir <naziirr@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 4:36 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Most hardware UARTs actually can't do this but the kernel will do its
> best. The POSIX interface you want is tcdrain(fd). Quite why POSIX didn't
> use fsync is a very good question.

Thank you so much !

>
