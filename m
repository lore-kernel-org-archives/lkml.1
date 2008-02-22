Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbYBVCbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbYBVCbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbYBVCb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:31:29 -0500
Received: from web53803.mail.re2.yahoo.com ([206.190.36.198]:47017 "HELO
	web53803.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757605AbYBVCb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:31:29 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 21:31:28 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=XIqw6v2bCCiMXEpyutI3TQKwOUgMqg0zLq4HQ2K9FP8qwhG2aoSXCmDDtaG8vSjLvu3WUXJpzJRSMRyjGyuzuAWaPiZReWrzTGn2Qk4n4TF3hJAoLGfzrEKwutMjKxGpac34G7BC9pv4radRlORTJB/K5aLHh9KaRJCT2DEd1pc=;
X-YMail-OSG: m_6MNDgVM1k4Knr11bs8RKuUk6d5zR5LOXPk.KrWm6MXjaIezP.RspOc_0zm2XnyDv51aNstl.nY7_i_iJdkgvkrXEg9c9NASBkLv.MexGwpVB3nskH.N90S_JfMmZ90c1b0Jw7sRTrRFz8-
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.162
Date: Thu, 21 Feb 2008 18:24:47 -0800 (PST)
From: <caiying@yahoo.com>
Subject: Configure MSI-X vectors to target different CPUs
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <852306.69189.qm@web53803.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In MSI-HOWTO, it's said:

"Using MSI enables the device functions to support two or more vectors, which can be configured to target different CPUs to increase scalability."

So how can I set up MSI-X vectors to target different CPUs? I want to allocate the same number of MSI-X vectors as CPUs, and equally distribute them to every CPU.

Is it automatically done by Linux when I call pci_enable_msix()? If yes, how? If not, what should I do? My guess is to set the affinity of the interrupts manually. Am I right?

Please CC'ed me (caiying@yahoo.com) answers/comments  in response to this posting. 

Thanks,
Ying


