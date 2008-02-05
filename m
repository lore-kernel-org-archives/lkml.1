Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYBEAca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYBEAca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbYBEAcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:32:20 -0500
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:30016 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756935AbYBEAcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:32:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=hpESCeePOZiHwUC9xpKhMVLfL9+N86YxtMa2nD31/PCMllJgH6DLzJkZDGLV0WSzcX9gnadL+5UmMO+i4Trb/YiRzKGHjzEYz0Uo2WpQL1MTkM2n1bwHDU6DwaBgi7AkmK/5eA21dxRIHPEcohmEWH7Qh7KKMWPjSKM2/m2KHAA=;
X-YMail-OSG: Y108eJ4VM1nJeLDYSl7Ep50D83ZRzMfIkoh8vJrjW1CUzMTw3_gnkwjdyBm.DO4ogWcVIg--
X-Mailer: YahooMailWebService/0.7.162
Date: Mon, 4 Feb 2008 16:32:18 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] enclosure: add support for enclosure services
To: linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
In-Reply-To: <1202074856.3318.111.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <50030.21278.qm@web31808.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sun, 2/3/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> The enclosure misc device is really just a library providing
> sysfs
> support for physical enclosure devices and their
> components.

Who is the target audience/user of those facilities?
a) The kernel itself needing to read/write SES pages?
b) A user space application using sysfs to read/write
   SES pages?

At the moment SES device management is done via
an application (user-space) and a user-space library
used by the application and /dev/sgX to send SCSI
commands to the SES device.

One could have a very good argument to not bloat
the kernel with this but leave it to a user-space
application and a library to do all this and
communicate with the SES device via the kernel's /dev/sgX.

   Luben

