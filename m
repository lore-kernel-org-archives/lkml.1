Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXCGQ1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXCGQ1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbXCGQ1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:27:50 -0500
Received: from va-65-40-217-47.sta.embarqhsd.net ([65.40.217.47]:9952 "EHLO
	CVAEX1.VERTICAL.COM" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932433AbXCGQ1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:27:49 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: tiny tty driver sample
Date: Wed, 7 Mar 2007 11:27:48 -0500
Message-ID: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: tiny tty driver sample
Thread-Index: Acdg0iEKoWS2LvlfSuKupaaVuyzHwA==
From: "Jon Ringle" <JRingle@vertical.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to write a tty driver and I'm using
http://lwn.net/images/pdf/LDD3/ch18.pdf as a guide. The sample tiny tty
driver includes the following code:

            for (i = 0; i < data_size; ++i) {
                        if (tty->flip.count >= TTY_FLIPBUF_SIZE)
                                    tty_flip_buffer_push(tty);
                        tty_insert_flip_char(tty, data[i], TTY_NORMAL);
            }
            tty_flip_buffer_push(tty);

This doesn't compile against Linux 2.6.16 kernel I'm using, because
tty->flip.count doesn't exist anymore.
How should this sample be re-coded?

Thanks,

Jon
