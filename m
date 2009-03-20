Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZCTBks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZCTBks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZCTBki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:40:38 -0400
Received: from web15705.mail.cnb.yahoo.com ([202.165.102.72]:20816 "HELO
	web15705.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751689AbZCTBkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:40:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=v1408lwJRwnwvdpdcUj9SkFzkYINBdurCJnOOdQRgpsZb7JnVi8Hhb2hv1wzscfIzLDitgAKSnpJjchOlyeK2zcaDHvb0ynRusF8AEC9VSkZLpd811fm35V8gPI081ai8HUTS20cR+LbZvesQrnC5SiX31NDFvqpDDY8WjgTXWc=;
Message-ID: <768318.39103.qm@web15705.mail.cnb.yahoo.com>
X-YMail-OSG: k1NeyDwVM1lbEJ9yTo3LtLuaJX3_r.mv_SJKXRps1hU_p7CLiJcoW9xlq4wrrvx.A_aAfmk0FSg4HW2zseFt1IeCsVQkh5Lph2wdmiEFVZtID3FP3J3zb_VtL50ZquP.duEcqOaNDXYLFvZokqs6GLHu4BTgalhQvt6IihiPnC1GTs8-
X-Mailer: YahooMailClassic/5.1.20 YahooMailWebService/0.7.289.1
Date: Fri, 20 Mar 2009 09:40:33 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Subject: Ask a question about major and minor number of keyboard driver .
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

 Such as drivers/input/keyboard/neo1973kbd.c :

 input_dev->name = "Neo1973 Buttons";
 input_dev->phys = "neo1973kbd/input0";
 input_dev->id.bustype = BUS_HOST;

 As i understand , application will access /dev/input/neo1973kbd/input0 as input handler such as open(/dev/input/neo1973kbd/input0) .
 I want to know which minor number will be used by input0 , because event0 
 will use minor number 64 .
 Assume no minor number for neo1973kbd/input0 ,how the driver process open(/dev/input/neo1973kbd/input0) ? because no major and minor number related to it .
 

ls -l /dev/input/ 
crw-r----- 1 root root 13, 64 2009-03-20 08:54 event0


Thanks in Advanced .
Best Regards.
Peter Meng 




      
