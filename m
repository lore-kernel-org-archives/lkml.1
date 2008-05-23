Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYEWMOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYEWMOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYEWMOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:14:42 -0400
Received: from www.tglx.de ([62.245.132.106]:43973 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYEWMOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:14:41 -0400
Date: Fri, 23 May 2008 14:14:32 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Tom Spink" <tspink@gmail.com>
Cc: "Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?=" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
Message-ID: <20080523141432.13dc9212@bluebox.local>
In-Reply-To: <7b9198260805230500l6b21a397m6951a2b1115a6f5@mail.gmail.com>
References: <20080522192252.GB3226@local>
	<20080522192637.GC3226@local>
	<7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
	<20080522200814.GD3226@local>
	<7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
	<20080523054115.GB28807@digi.com>
	<7b9198260805230448x56bf3bd1kade6083c141a75f2@mail.gmail.com>
	<20080523115815.GA6932@digi.com>
	<7b9198260805230500l6b21a397m6951a2b1115a6f5@mail.gmail.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 23 May 2008 13:00:17 +0100
schrieb "Tom Spink" <tspink@gmail.com>:

> My initial idea was just a thought anyway, just to
> maintain a bit of extensibility if .write is ever needed for something
> else. :-)

Hi Tom,
thanks for your contribution, but for me it's just the other way round:
I'm glad write() gets a defined purpose before people do something
stupid with it. It's good to remember that all data exchange with the
device has to be done through the mapped memory. If this is not
possible, the hardware is no candidate for a UIO driver.

BTW, I wait for the first UIO driver which abuses this write()
function to write many different values to trigger different actions.
I wonder if I should restrict write() to the value 0 and 1...

Thanks,
Hans
 
