Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbXJ3UZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbXJ3UZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbXJ3UY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:24:29 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:44703 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756640AbXJ3UY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:24:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XJmM5thZKA2//4iYB4pudGFqi7hT229AGD7SOSNI+D7fFvYdNtv4C+1EIgiPMzMULZ0qrer2UrS1VxYkQa4UTaJTd0VxfQXb9di4reKHHoZgdaEKNf6Mqt+LAAOpH2r9ZEAsNUxrOsA+s+2O6SEzRZ67SQGeTqI2AsAhPtHHPGg=  ;
X-YMail-OSG: 2YdxlZIVM1kc4hgoy7XN2Z5cM6c7MW1elVZpF135iETwvsn0pi0f65SBcvr6yVI0B858cti9QxzZlqUc0IyYY8WjWZx9Wk6USPE2WIHHdKqASF5RGg--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 00/14] Blackfin on-chip SPI controller driver updates and bug-fixing
Date: Tue, 30 Oct 2007 13:24:07 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301324.07691.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007, Bryan Wu wrote:
>  - BF54x supported
>  - multi-port supported
>  - bunch of bug fixing 

OK, I forwarded these with some more checkpatch.pl fixes.

But as I commented elsewhere, please work harder to make sure
that your patch comments actually match the patches!!

And also, pay closer attention to when you may be making
changes that make device drivers work differently over
your spi_master controller driver than anyone elses ...
such platform-specific behaviors are undesirable, and when
they go against specified behavior they are also bugs.

- Dave


