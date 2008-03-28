Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYC1Q06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYC1Q06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYC1Q0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:26:50 -0400
Received: from web28604.mail.ukl.yahoo.com ([87.248.110.213]:21273 "HELO
	web28604.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753921AbYC1Q0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:26:50 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2008 12:26:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=AtJMqlLBm0OvE0hg43OkVb6g5wBZXox9E5C4LiR/H1ykrujfXvGrWWdH1zkAG27QZjINujgijQIRIIx1WN/1Z/tO58o3S8/ONgO9kq6LyXpVPIbAuo4lHbVfCpZQXwcKJACnXFNTJm1Pht0381beo2iaPo9ePRVm1FupHHs9raw=;
X-YMail-OSG: KcRcXDgVM1l6I9.JzgptmTrhJnBsDASIQmhb6uEY_nGFy7abeU0ebqKzaoIRUB7R4GqLnH1XueUiYxGxLvNO.qBkP44Wniv4y.PV21nBMqDSE9vZXLtBIV.X0Eg-
Date: Fri, 28 Mar 2008 17:20:07 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: PATCH one line: "vmlinux*.lds*" is in Documentation/dontdiff
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <219221.75156.qm@web28604.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

 Please can you remove vmlinux*.lds* of Documentation/dontdiff from linux-2.6.24-rc7,
because a command like:
diff -urN -X linux-2.6.24/Documentation/dontdiff linux-2.6.24 linux-2.6.24-gujin
 does not include modifications of file "arch/x86/kernel/vmlinux_32.lds.S".

 Note also that the two files vmlinux_32.lds.S and vmlinux_64.lds.S have few lines
which begin by "space space tab", but I do not want to start a flamewar in between
vi, emacs and this other text editor...

 Thanks,
 Etienne.


      _____________________________________________________________________________ 
Envoyez avec Yahoo! Mail. Plus de moyens pour rester en contact. http://mail.yahoo.fr
