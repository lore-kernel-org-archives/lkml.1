Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbZHZBcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbZHZBcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbZHZBcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:32:03 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:64525 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbZHZBcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:32:02 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 21:32:01 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=hT9ujY92u+pDDhEYu+Z0arCB4noNOAA1ivjzp1Z8Uw4FfzuWqt9IddAa6fIUfpox6N
         VDwc/kF/NdfpRwVVcesEfIWjaBfRGkVkNgjUb1Kl8lycQz6ls3XsfeuJ6ygFahHQdLYN
         hmE59jDuS33NfPPLTqgXMIMRZjEahRUWzApQw=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 09:25:03 +0800
Message-ID: <30c949580908251825n59da4bceg77c464eca01f0c46@mail.gmail.com>
Subject: oom-killer works,but the memory cannot be freed
From: Bill Xie <bill790@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My harware is a mips-achitecture hand-hold device, runs 2.6.24.3 and qt.
when an application program  opened a 3.2M pdf file, the memory was
consuming continually, finally the "oom-killer" things happened, the
applicaton was killed,
 but the memory occupied by the application still can not be freed. Is
there some methods
to do with this situation?
