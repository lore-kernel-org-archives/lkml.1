Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYGYRMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYGYRMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYGYRMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:12:34 -0400
Received: from web53310.mail.re2.yahoo.com ([206.190.49.100]:43958 "HELO
	web53310.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751652AbYGYRMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:12:33 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 13:12:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=pSc9cLnWC6l6obJ6Wfni4/+ydUFT55qyZpVyZEgZ17Kn0dnKM39W0eDqXe7xIdxKONAe2ZPMFvsr2TId1R3PZcjALvQ9ZAj1aQkea1kL1IVHimrcrRw/H3dikzNA4ROcTXQISgOYpkmtrpO5ybbKNQLeQEDLh5weT/4mqypgbSI=;
X-Mailer: YahooMailWebService/0.7.218
Date: Fri, 25 Jul 2008 10:05:52 -0700 (PDT)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: How to disable group scheduler correctly?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <842240.12654.qm@web53310.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Could anyone tell me which options to enable/disable to have the scheduler behavior as it was before 2.6.25 (i.e, completely disable the group scheduler)? There seems to be a lot of confusion [1] about which options to set or not set, so it would be nice if anyone could give the exact ones.

Thanks.

[1] For example, in Arch Linux the group scheduler was first enabled in 2.6.25, but due to latency issues it was quickly disabled. But after that, the following report claims to have problems with everything *GROUP* disabled and that you need to enable CGROUPS to solve them (the report links to similar reports on Gentoo and Ubuntu, so it seems the confusion is quite general):

http://bugs.archlinux.org/task/10512



      
