Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXCKHWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXCKHWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 03:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXCKHWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 03:22:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:1035 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXCKHWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 03:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KLATk3lRN9EdgQgG3eD7aIMh7Kk1mVBoWX9okBbLQmpeZi20V0XbBU6r0ztbgfmIBpP0KhnTGPaEte1jAskZd6hyxypamuQeIWwI0sY/v6dE7A7rciWChL4MgxDc0ux9lCp+GSks1wOK168VoGeSallp6gGuifZW/zaRumTPMeU=
Message-ID: <3aac340703102322p362998b9labedc13503702d2b@mail.gmail.com>
Date: Sun, 11 Mar 2007 09:22:50 +0200
From: Vitaliyi <imgrey@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: libata extension
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good Day

Say i want to implement extended set of ATA commands available to
userspace for building diagnostic tools.
I need 0x40 -- read verify and 0x32 -- write long with error handling,
for example. I was trying ide driver through ioctl's, but seems it
lack of functionality and full of gotchas. Furthermore it oopses
sometimes.

Is it possible to use libata for such purpose or i need to write
separate IDE driver ?
By the way, i'm sure it should be done in kernel space since i'm going
to deal with some hdd manufacturer commands.

P.S. I was looking through libata and ide sources and documentation
but still dont have broad picture.


Thanks
