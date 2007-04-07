Return-Path: <linux-kernel-owner+w=401wt.eu-S966119AbXDGQ5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966119AbXDGQ5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966114AbXDGQ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:57:35 -0400
Received: from web86911.mail.ukl.yahoo.com ([217.146.177.83]:32144 "HELO
	web86911.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966115AbXDGQ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:57:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=JwO/iTgVYgCrAXaIYIneTnTMV/4Z8tGV6gmlJtG5mQFQ8AlS34wFeQQBiYSjVHb4ZYrVILLn0qAmdNdH04a/qE+OCGyV1qKd+c0n0NkHx7SrV2Cf8qcUPxvEJpz5nq4pOaUDFe28CMWuPP5FTvOjS2Gur/IA34QINt3jz79//GE=;
X-YMail-OSG: B.MDLo8VM1ktzTuWc5bsCpxLTjZsRMlYo6c7sJngRn9F9nnATR0Kz8T.KwIQFMJ3eclm30YrfPbtQPoF1AOEYnY-
X-Mailer: YahooMailRC/478 YahooMailWebService/0.7.41.8
Date: Sat, 7 Apr 2007 16:57:32 +0000 (GMT)
From: JanuGerman <doublemalam@yahoo.co.uk>
Subject: Re: Two questions regarding Opening files within Kernel!
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linuxkernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <249860.22361.qm@web86911.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jan for the response.


>struct dentry *foooobar = lookup_one_len("/foo/bar", current->fs->root);


But that gives me a dentry, where as file object is still not reachable. 

Question: I am currently using a function called fs.h/dentry_open which takes a "dentry", "vfsmount" object  and flag (usually RW i.e. 2), and gives me the file object. with  your suggested method, vfsmount is still not available. In this regard, any idea about a function, which gives directly the file object instead of dentry will be highly appreciated. 


OR,  (Kindly see the code below), i need some thing for "missing vfsmount".


    struct dentry *foooobar = lookup_one_len("/foo/bar", current->fs->root);
    struct file *file1 = dentry_open(foooobar, "missing vfsmount here",2)



Thanks,
JG


	
	
		
___________________________________________________________ 
New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
