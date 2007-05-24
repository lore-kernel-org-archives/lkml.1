Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbXEXVFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbXEXVFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbXEXVFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:05:00 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:46600 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbXEXVE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:disposition-notification-to:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=fsOLWofvV+qynC5mpFb5+OEHCg4BaxPEv9dWt0M5GA4tjKTAv1Aq7sNghNq9/K6tHohlRGWjvzpl7eRjdaqkK+H7UkUzt5d+kTd+EStn6zji5lwX7SRwFDzkM6C2x9pAavoVKD9iLWkjhSuNP742UVg/1DZgMnJMibXiAMm5ESI=
Message-ID: <4655FDEA.30209@gmail.com>
Date: Thu, 24 May 2007 16:04:42 -0500
From: Fabio A Correa <facorread@gmail.com>
Organization: Universidad Nacional
User-Agent: Thunderbird 2.0.0.0 (X11/20070429)
MIME-Version: 1.0
To: Damien Wyart <damien.wyart@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 and libata/shutdown
References: <20070524102122.GA8652@localhost.localdomain>
In-Reply-To: <20070524102122.GA8652@localhost.localdomain>
X-Enigmail-Version: 0.95.0
OpenPGP: url=http://facorread.150m.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello Damien, people...

Damien Wyart wrote:
> Hello,
> 
> After trying 2.6.22-rc2, I noticed the warning message from libata about
> upgrading shutdown(8). First, I have two SATA disks, and get the warning for
> only one of them. Second, I double-checked the source of shutdown for my
> distro (Debian unstable), and do not see anything related to issueing
> STANDBYNOW.

The warning is pretty important, and you can check it at

http://linux-ata.org/shutdown.html

I have been checking the sysvinit sources and I cannot see the portions on scanning SCSI or SATA
disks. I only see the IDE scanning and standby-related code at src/hddown.c. Does anybody know
how in the world are the SATA disks put to sleep in userspace?

- --
Fabio A. Correa D.

Physics Dept, Universidad Nacional, Bogota, Colombia
facorread@gmail.com
ffaaccdd@yahoo.co.uk         facorread@unal.edu.co
My webpage and OpenPGP key at http://facorread.150m.com
facorread@alexandria.cc is not working anymore!!!
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGVf2HYOZCB4zf2uQRAhwIAKDJz/81ZaEIoN3ehWGBooKiiKkaogCcCj/i
d+8GAY5x/yV1La3U5vx0zbk=
=+aJc
-----END PGP SIGNATURE-----
