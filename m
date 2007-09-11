Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXIKWLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXIKWLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXIKWLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:11:35 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50342 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXIKWLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:11:35 -0400
Message-ID: <46E7128D.1080006@gmail.com>
Date: Wed, 12 Sep 2007 00:11:25 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian McMenamin <lkmladrian@gmail.com>
CC: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: time_after - what on earth???
References: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com>
In-Reply-To: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2007 12:05 AM, Adrian McMenamin wrote:

> OK, why does this line occasionally return true:
> 
> 	if ((maple_dev->interval > 0) && (jiffies >maple_dev->when))
> 
> while this one never does (no other changes made):
> 
> if  ((maple_dev->interval > 0) && (time_after(jiffies, maple_dev->when)))

Is maple_dev->when an unsigned long?

Rene.
