Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZASUU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZASUU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZASUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:20:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:56522 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZASUUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:20:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=KvpCFCZ2yfGaahaSf97l5AuV/utGYWhwNhowaXHI6UIlzWfHmAYUyxt6GPcj8YXNik
         P29bKpoo8eO4ZhOXVHt6yaRFxk7HYlyyOQbHIGa3zLRgzZ9zlHFw0swtXY59Rjmli5Ee
         cajRResk/YhAnb+j7FE+rFxDNsWcrE94bXb3E=
Message-ID: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com>
Date: Mon, 19 Jan 2009 15:20:13 -0500
From: "Thomas Tuttle" <linux-kernel@ttuttle.net>
To: linux-kernel@vger.kernel.org
Subject: System hang (and other problems) with cdc_acm
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 956ded40f6bfe657
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I've got a Lenovo X200 with an Ericsson F3507g Mobile Broadband Module
(a 3G cellular data card with built-in GPS), which uses the cdc_acm
driver.  I've experienced a couple of problems with it.  First, it
tends to hang the system after I've been using it for a while.  This
occurs whenever it's sending a lot of data to/from the computer,
whether it's a PPP connection or a GPS data stream.  I'm not sure how
to debug this; the Caps Lock light isn't flashing, so I'm not sure if
it's a panic or just a hang.  Second, if I read one of the TTYs using
"cat", I get a ton of blank lines.  To make any sense of the data
stream, I have to do cat /dev/ttyACM0 | grep -v "^$".

If anyone could help me debug this, I'd be greatly appreciative.

Thanks,

Thomas Tuttle
