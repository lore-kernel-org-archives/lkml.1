Return-Path: <linux-kernel-owner+w=401wt.eu-S932833AbZHEAsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbZHEAsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932633AbZHEAsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:48:54 -0400
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:39410 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932403AbZHEAsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:48:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
Date: Tue, 4 Aug 2009 20:48:49 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901B7783E@mi8nycmail19.Mi8.com>
In-Reply-To: <200908041414.26112.david-b@pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
Thread-Index: AcoVY6pgwzlhMLXVQwuKWNNpG2nh8wAAfi2w
References: <200907311027.06370.hartleys@visionengravers.com> <200908041414.26112.david-b@pacbell.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Brownell" <david-b@pacbell.net>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Aug 2009 00:48:51.0702 (UTC) FILETIME=[804F7960:01CA1566]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 04, 2009 2:14 PM, David Brownell wrote:
> On Friday 31 July 2009, H Hartley Sweeten wrote:
>> gpiolib: introduce for_each_gpio_in_chip macro
>> 
>> There are a number of places in gpiolib where all the gpio's handled by a
>> chip are walked thru using a for() loop.  This introduces a for_each_*
>> macro to clarify the code.
>
> I'd rather not.  There are four such loops, and these are
> really simple iterators.  Such a macro IMO just obfuscates,
> when it's just hiding such trivial index ops.
>
> NAK.

Ok.

For the record. The reason I sent this is I'm trying to work out an
extension to gpiolib that adds gpio_port_* access to the API.  Most
of the gpiolib drivers already the necessary logic since the raw I/O
is performed on the entire 'chip'.  The API just needs the extensions
added to request/free the port, set the direction and get/set the value.

Is this a worthwhile addition?

Regards,
Hartley
