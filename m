Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZIILDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZIILDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZIILDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:03:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50450 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZIILDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=klXZeroOMo27OHCNTQlOraFcuCKdMVA2Go84WoU3IsuuHEwlOZIFmdS0sWAzM77IFS
         XsLVwlBETJP9BZzHTEw8T2wBsCTHpE5m/m6hpdiNL6AE1TX50ttj54/VLOcCGX4zdao7
         um9K25SkMoCHSJkptOG1NAv6NqyTgdYZLc9eg=
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 07:03:36 -0400
Message-ID: <194f62550909090403x16e61cc1g3a23593085de0b@mail.gmail.com>
Subject: Howto switch off ext4's delayed allocation?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Every since switching to ext4, I suffer fromt he empty files problem
after crashes.
Since GEM/KMS was included, as well as the changes to the usb-serial
subsystem I experience crashes from time to time.

As far as I understand this is caused by delayed allocation.
I really enjoy the performance benefits of ext4, and I know
applications should be fixed - but having this problem seen with so
many apps I doubt it will ever happen. (Kwrite, bash itself, umtsmon,
...).

Is there any way to disable delayed allocation? (running 2.6.31rc8)

Thank you in advance, Clemens
