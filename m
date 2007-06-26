Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXFZGwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXFZGwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXFZGvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:51:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64364 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbXFZGvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S0fEImffiUUwanX0LZPs54/cBDF/Lipfu7zB9mFzcg5Ta9WcWQzXgd7/FV2UDYiZdFzDcSDn3OlKaFq59gakyYfqkmKuqvaTx2Vjn+B8PyJ1PCn/L2Vj6FtsPbRXnkb7Jm/2+2fDKEUYA3CD3WImYu0DxVDrdcVMAadSCYqEsBo=
Message-ID: <cf9d85500706252351k68924882s2c6bc58454d1bb9b@mail.gmail.com>
Date: Mon, 25 Jun 2007 23:51:51 -0700
From: "Amitabha Roy" <amitabha.roy@gmail.com>
To: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: DIE_NMI_IPI to oprofile ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>From looking at the default_do_nmi code in traps.c it seems that (at
least for the non BSP case, with reason=0) the die notifier chain gets
called with val=DIE_NMI_IPI.

However in the profile_exceptions_notify_handler we check for DIE_NMI
(and not DIE_NMI_IPI) to decide if we want to cycle through the
counters. This seems wrong to me unless I am missing something (which
must be the case, otherwise this code is broken :).

Can anyone help me understand this ?

Thanks
-Amitabha
