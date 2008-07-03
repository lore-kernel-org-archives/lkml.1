Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYGCRws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYGCRws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYGCRwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:52:40 -0400
Received: from web30302.mail.mud.yahoo.com ([209.191.69.64]:38635 "HELO
	web30302.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752262AbYGCRwj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:52:39 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 13:52:39 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=y+++D7iFpP/T2VoxaDotfeau8fSXi3u9ZrGX5uEyhp/usFCkVJ6dxhBD2muVhAOpvGIacsY6I6z84UPp8RgAw8K6DpegbP1vLnP5tE++p5QzJD274BIqrf0I+TRgrx9RO5OAtuURDoEbEPl8MTzHUw0xWNG8TVGDKZwroL/yBvw=;
X-Mailer: YahooMailWebService/0.7.199
Date: Thu, 3 Jul 2008 10:45:58 -0700 (PDT)
From: =?iso-8859-1?Q?Arne_W=F6rner?= <arne_woerner@yahoo.com>
Subject: ivtv / read() blocks for more than 2s sometimes
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <447967.92298.qm@web30302.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I use fedora core 8 x86_64 (athlon64 X2 5000+, 2gb ram, asrock mb) and update the packages whenever yum-updatesd notifies me...

About once a month
(i reboot about daily and record about 10-15 hrs of tv shows per day
 (mostly from just one tv card at the same time))
one of my 2 hauppauge pvr 250 cards or their ivtv kernel module refuse to provide a read() call with data.
Whenever that happens my selfmade recording program closes the device issues "/usr/local/bin/ivtv-tune -t europe-west -d /dev/video0 -c E9" 4 times. Then it tries to read again from it.
That repeats 5 minutes and then i reboot automatically, so that i loose about 7 minutes each time...

Is there an easier way?
Can I reset a single pci device
(e.g. by detaching the driver of a certain pci device and re-attaching it)?

Thx.

Bye
Arne


      
