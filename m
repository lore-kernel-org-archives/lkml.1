Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXBUKrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXBUKrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620AbXBUKrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:47:01 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:47346 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbXBUKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VOwBODFGcx4DCn57CcDQa7CbTpom1Lbfyjx2ZeYn2s6PIjMxbLqoTwjdy1yXriu2e0nxyh2l52AKn1ga0Zju5PSRuaVMtJIydYoq23T4Oc84Y2XJ5yelMzEzdwTNszjG4voC1se2PIwpVYPtzKMPl4FPmzRw5aOpBtLbXtqf6mY=
Message-ID: <9a8748490702210246j38a1ca4bi8de371ba6829ada9@mail.gmail.com>
Date: Wed, 21 Feb 2007 11:46:58 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: nfs@lists.sourceforge.net
Subject: 2.6.13.4 - "lockd: weird return 1 for CANCEL call"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I just got a unusual message from lockd on a webserver running a
custom compiled 2.6.13.4 (yes it is ancient, I know).

# uname -a
Linux webserv.somedomain.example 2.6.13.4 #1 SMP Wed Nov 16 10:03:05
CET 2005 i686 unknown

# dmesg | tail -n 3
do_vfs_lock: VFS is out of sync with lock manager!
lockd: weird return 1 for CANCEL call
lockd: weird return 1 for CANCEL call

The server seems to be running fine, so I'm not really worried, but I
thought maybe someone would like to know. :-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
