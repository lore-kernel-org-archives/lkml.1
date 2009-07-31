Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZGaMcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZGaMcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZGaMcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:32:12 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35301 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZGaMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=GOa+viXh/q0mCx31lXkamSsubX9zRXrjxohDhO2xK2cNF/WHp+WpwBmYp8oWp9kCJ3
         GlV/17DnhLqJUfWrj7xwfV1fit+d96FBdt+ldGMGJd7248fVnsaDBStqqBWsibKmD89m
         mOwFFIxzl7TfIJ7qAfMp8bRPWDa7NbaZArKJU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RTL8192SE support status
Date: Fri, 31 Jul 2009 14:31:16 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907311431.17043.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've been getting some private mail regarding the status of RTL8192SE
wireless chipset support (the chipset is used in some newer netbooks,
i.e. Medion Akoya E1312) so the current situation is:

* I'm not working on it and I don't know if/when the driver is coming.

* Realtek has been queried about the issue two weeks ago but we haven't
  heard anything back yet.

* rtl8192su driver present in staging area of the kernel is for RTL8192SU
  (USB version of the chipset) and never contained working/complete code
  for RTL8192SE (PCI-E version of the chipset) so there is no point in
  attempts of reverting some patches in hope that it will make the things
  magically work (it won't, please save your time).

Thanks,
Bart
