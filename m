Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYIWRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYIWRp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYIWRpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:45:21 -0400
Received: from web50901.mail.re2.yahoo.com ([206.190.38.121]:44612 "HELO
	web50901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752687AbYIWRpU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:45:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 13:45:20 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Lwc8yvs358rztofZEFf3cIBWd0TPKXxdVonFe+C1ZbrXe3JWY/tDOOYJERGlHuqDMf5VVD35F7xRPuKa7WmfXcGJUZseMklFXIkvKYKc7f6nTbt5acoZJlnAbc5A2ux8tFKq6U9C+pqsVh6ZtpMFWbFMNTywiNNSQh0/nagT/3M=;
X-YMail-OSG: 8APR37QVM1nwFdFC4F203uwuFKP.GQYJTJBz.TRa6KWKv0XHqxPUv15pXom5j9qSSQ--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 23 Sep 2008 10:38:37 -0700 (PDT)
From: Joilnen Leite <knl_joi@yahoo.com.br>
Reply-To: knl_joi@yahoo.com.br
Subject: about kernel_physical_mapping_init
To: linux-kernel@vger.kernel.org
In-Reply-To: <1222190371-23814-4-git-send-email-srajiv@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <511753.74328.qm@web50901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wondering if inside kernel_physical_mapping_init, we could put the line
  pmd = one_md_table_init(pgd);
after
  if (pfn >= max_low_pfn)
    continue;
and if this could to be a improve, one time it dont go to one_md_table_init in pfn >= max_low_pfn case

Joilnen


      Novos endereços, o Yahoo! que você conhece. Crie um email novo com a sua cara @ymail.com ou @rocketmail.com.
http://br.new.mail.yahoo.com/addresses
