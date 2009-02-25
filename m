Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZBYVZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZBYVZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbZBYVZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:25:34 -0500
Received: from web39803.mail.mud.yahoo.com ([209.191.106.64]:23088 "HELO
	web39803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756381AbZBYVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:25:33 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 16:25:33 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:To:MIME-Version:Content-Type:Message-ID;
  b=hlJFgYac7OeOIuxsdt9g1ui91dUsnDvhzOOmviosnchBUvkgDXJklZN5R3O/7warwBobvA80dVvmyzfxJo9Asw9D9K9a7tYWVA/PdRLE4PLe6vJkrP2jMqiKd31tbnm5L/3fCfI4+6eyYhB9pENMxahxsIZxL6TI9Od2CwsgYSk=;
X-YMail-OSG: pLQAjrMVM1lgbtlyWtSEa5iWTYjmBt_PwYM0mNU1scZcrH6Hn5F_vMp0iH6maZApYNOxy03Vk7JjdSBG1jeT5iOkah6D2WU1Z3vUwJ30N9aQFd_R5nWK.5.A9Pqyt9o9S9VHdHdhEg_1aVtC6MYbPlJkV8tpkn9cfTJgUPl6x6i60e8Q.WiqRVWxdwZy.A--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
Date: Wed, 25 Feb 2009 13:18:50 -0800 (PST)
From: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <684823.94105.qm@web39803.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Folks,

I am trying to port some PPC code to x86 based linux. My question is that I am need to create some page mappings using remap_pfn_range. In the code for the PPC,
the protection flags being specified are:

__pgprot(_PAGE_NO_CACHE | _PAGE_GUARDED);

But it looks like these do not exist when linux is compiled for the x86 architecture. 

What are the relevant protection flags to achieve the same for the x86 architecture. 

Thanks for any help.

- Vinay



      
