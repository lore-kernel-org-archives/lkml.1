Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYDMVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYDMVSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYDMVSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:18:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:21243 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYDMVSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SZNmemMUB4Xspb+bC0VWFnooW5bo3A2eXS1afQNJ5eVcTmwJs8tMBDXzS3VHQTGNj+UpBG1mIBZsH1GXDaq98jcKAZw1zNEKjhD9mE+THWAwUS85Cw4cIC5Gg956lIm9q8bzNaZiecVz9jKjk4qFy0LrCBFGkqlur5vUbeY8xpk=
Message-ID: <740b8bba0804131418q4a210d44k77f95714002b92a@mail.gmail.com>
Date: Sun, 13 Apr 2008 14:18:15 -0700
From: "David Erickson" <halcyon1981@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel module unable to find an exported symbol
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone, I have two kernel modules I am developing, both use the
call_rcu exported function. The core module finds it no problem,
installs, and uses it.  The second module however when I try to insmod
it complains:

Unknown symbol call_rcu

I have verified that it is exported via /proc/kallsyms:
c04348c8 T call_rcu

I am at a loss as to how to proceed, can anyone shed some light on how
this could be happening? Or how to diagnose and debug the problem?

Thanks,
David

ps please CC me on a reply, thank you!
