Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176Ab0A0AtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0A0AtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912Ab0A0AtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:49:10 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:56050 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab0A0AtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:49:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=w4/LZcFsEhE1Cw76VA9UOnNF1rqAneL/WGQA4BbpwsxEJcXb525+LdWP/jZqCz9N7i
         k/iMyTtT71byEGvwLql5oBQB39xLb9i5dAyFZiOYGsOnQtg5w1z579aPgSyZToZvGbEZ
         4WcBOrWiCt9AxGHwIL8aLvpemEYkgbjqdr7MQ=
MIME-Version: 1.0
In-Reply-To: <72dbd3151001261632t7bbe43d0nb7490eae02185c81@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
	 <aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
	 <72dbd3151001261632t7bbe43d0nb7490eae02185c81@mail.gmail.com>
Date: Wed, 27 Jan 2010 06:19:05 +0530
Message-ID: <aacba7e1001261649v6f5cc037h41adcf253b978386@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: David Rees <drees76@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 David Rees <drees76@gmail.com>:
> So my concern is that you're proposing to black list NCQ for all users
> of those particular models of SSD when it's more likely at this point
> that it's a problem with your specific setup.

Yes, a valid concern. I guess I didn't delve more because it's working
fine on my copy of Windows 7 RC (on the same hardware) with no sign
of error logs and pretty much the same perf as Linux with NCQ forced off.

What I can do personally is plug in my SSD into my tablet PC sitting next
to me and do a few more tests and get back to you all - it could be a couple
of days. I know its still just one user (me) reporting though.

FYI I had posted on the manufacturer's website/forums (quite active with
a lot of owners) and got NO response indicating there aren't too many
Linux users with this model - again "can't prove a negative" sort of way.

In any case, the workaround (should anyone face this issue) is to simply
add " libata.force=noncq " to the kernel boot options.
