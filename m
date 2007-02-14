Return-Path: <linux-kernel-owner+w=401wt.eu-S1750820AbXBNXqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750820AbXBNXqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXBNXqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:46:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43355 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXBNXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:46:14 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45D39F20.4050907@s5r6.in-berlin.de>
Date: Thu, 15 Feb 2007 00:45:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.5) Gecko/20041217
X-Accept-Language: de, en
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tilman Schmidt <tilman@imap.cc>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Manu Abraham <abraham.manu@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
References: <1171059433.8675.195.camel@laptopd505.fenrus.org> <200702122131.33662.rjw@sisk.pl> <45D18805.9080607@imap.cc> <200702132024.20053.rjw@sisk.pl>
In-Reply-To: <200702132024.20053.rjw@sisk.pl>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> Why a new flag?
> 
> For example, there are drivers that define .suspend() and .resume() which
> do not work correctly and we can use the flag to mark them.

Depending on how serious the problems with these .suspend/.resume()s
are, you could also put a printk in them or #if 0 bad_code #else return
-ENOSYS #endif around them.
