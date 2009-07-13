Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZGMQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZGMQoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZGMQoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:44:38 -0400
Received: from mail-vw0-f199.google.com ([209.85.212.199]:52263 "EHLO
	mail-vw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZGMQoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xFWLw7/6APct+x7dGo8zi7Gnqm7MOLe4HRA3tGMzaDwSndVtFbShCJSBbOJ3VifJcT
         JhAgj/Hm33Gcs1woYt8x3Oof9ByC5YhRpIAUZZ6ZLsVNzCD30F0hoj92e68UmF/Vx6JI
         yOx7CnpvEe1BG94Rzd7cslCX8PECj6QFCVP8s=
MIME-Version: 1.0
Date: Tue, 14 Jul 2009 00:44:37 +0800
Message-ID: <9b5c9bb30907130944l3624870ck507f5a9f0f79452b@mail.gmail.com>
Subject: linux-2.6.30.1 with gcc-3.4.6 compile error
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Anyone encounter the below error while compiling linux-2.6.30.1 with gcc-3.4.6?

drivers/net/igb/igb_main.c: In function `igb_up':
drivers/net/igb/igb_main.c:130: sorry, unimplemented: inlining failed
in call to 'igb_set_rah_pool': function body not available
drivers/net/igb/igb_main.c:938: sorry, unimplemented: called from here
drivers/net/igb/igb_main.c:133: sorry, unimplemented: inlining failed
in call to 'igb_set_vmolr': function body not available
drivers/net/igb/igb_main.c:939: sorry, unimplemented: called from here
make[3]: *** [drivers/net/igb/igb_main.o] Error 1
make[2]: *** [drivers/net/igb] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

This is CentOS 4.x system.  While using same configuration to compile
in CentOS 5.x systems with gcc-4.1.2 do not encounter such error and
my guess is gcc version issue?  Any idea?

Thanks.

Kindest regards,
Giam Teck Choon
