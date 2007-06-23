Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbXFWPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbXFWPwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 11:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXFWPwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 11:52:09 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:56399 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXFWPwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 11:52:08 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: "upping" a semaphore from interrupt context?
Date: Sat, 23 Jun 2007 17:52:07 +0200
User-Agent: KMail/1.9.7
Cc: "Arnd Bergmann" <arnd@arndb.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <20070622173839.GB8398@iucha.net> <200706231402.03617.arnd@arndb.de> <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
In-Reply-To: <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706231752.08494.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 23. Juni 2007 schrieb Satyam Sharma:
>          * 3. set up a timer and schedule another function to service the
>          *    interrupt / do what needs to be done then, hopefully the mutex
>          *    would be uncontended then => *gargh*

You could use schedule_work(). However then why not use it always.
This would make sense if what you want to do is outright trivial.

	Regards
		Oliver
