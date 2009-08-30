Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZH3H1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZH3H1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 03:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZH3H1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 03:27:52 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39574 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZH3H1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 03:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:organization:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fO27zFg57Bstb7aFkowbqFRwQ9hfJueCaW8Ac31UgGDF84Yli/OF6CAtX5UiGIDJk2
         A5DKTw65a76Og0B8hKPVLzPBM09AfCbwXcFwbZS9fgaGzavQ3RTFRr4j1HHbVQNraxKs
         Nt5jBu3yeMWlzjUB3S8t/A/aELaCa045IlYKQ=
Date: Sun, 30 Aug 2009 09:27:50 +0200
From: tartifola@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Lenovo compact cam 17ef:4802
Message-Id: <20090830092750.50e66b66.tartifola@gmail.com>
Reply-To: tartifola@gmail.com
Organization: Tartifola Inc.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I'm experiencing problems with a Lenovo compact USB cam. I'm using Gentoo
with kernel 2.6.30-gentoo-r4. I tried to use the built-in modules and
also with gspca-af183a871db8 form linuxTV with the same result. It
seems that the cam is correctly recognized

>dmesg
Linux video capture interface: v2.00
gspca: main v2.6.0 registered
gspca: probing 17ef:4802
vc032x: check sensor header 20
vc032x: Sensor ID 143a (3)
vc032x: Find Sensor MI1310_SOC
gspca: probe ok
usbcore: registered new interface driver vc032x
vc032x: registered

However when I try to use it, for example, with cheese I get this error

>cheese                                          
(cheese:21741): GStreamer-WARNING **: pad source:src returned caps which are not a real subset of its template caps
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error

Essentially Cheese does not show any available resolutions. Problems
also with xawtv

>xawtv
This is xawtv-3.95, running on Linux/i686 (2.6.30-gentoo-r4)
WARNING: v4l-conf is compiled without DGA support.
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
no way to get: 384x288 32 bit TrueColor (LE: bgr-)

and a similar issue with mplayer

Any help to debug my problem?
Thanks in advance

