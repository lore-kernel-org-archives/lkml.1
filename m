Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbZFLMac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbZFLMac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZFLMaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:30:24 -0400
Received: from web31706.mail.mud.yahoo.com ([68.142.201.186]:34879 "HELO
	web31706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750832AbZFLMaY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:30:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 08:30:24 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=QuMLhjSMvImDag8UgyAX1fGjafo+MQB6AsIGMKbeODbQ4HDIgK7c4+SNwebnIEqmqqyyIokFqwKWwIh51USHy0iIbsaTiSKPc6BvTVT551FpmuqItwMfov3rTW2bZoc7Wqdr7gxHRhKFMht0/V7DYGKSmUjjs0YkLrRi1zzQmBA=;
Message-ID: <233030.36441.qm@web31706.mail.mud.yahoo.com>
X-YMail-OSG: lrbmfv0VM1nvjfYqJXk_gaIiWgTr2wKQ3SHDM3rRB18T1A9kdk_Xd9VhfoSGmWVNNP601kITUMKdFDGaY0EIGA1KRwaW6Wem0G_7x_8bEyyKFdLwYki8DPfv6v8NRyYKriwn0K36Kgingt8mthz_unizrj6Y2MUoqepKroIU25mzliD22XsWVI5WMM2qie3bw1yHRtdFOahH5CV.uamW1xfsywKltZzChsJSajvWf_hympCYc_SW3SzIIbf0AGcoDpUJvjE2dLIjQrQnscGJsgjDMwDto3sCvZi3xl.X1zVX5D4liTj9zIgBkTvFqT6DQ.j_tQYXAtzk.AvkOTXeWvy4N5mI4rGrKa1XfzLR3qBSVC1dNq0cODHlMgbs0B8t
X-Mailer: YahooMailRC/1357.18 YahooMailWebService/0.7.289.15
Date: Fri, 12 Jun 2009 05:23:46 -0700 (PDT)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: PCIe interface memory memory mapping issue
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have developed a PCI express interface using Xilinx ML555 hardware module. I have implemented Linux kernel mode device drivers and everything works correctly as long as I am using the device within a computer with dual channel DDR arrangement. However, as soon as I pug this device into a core i7 or an older single channel DDR machine, the interface memory mapping does not work any more. As if the register map with in the device does no longer exsists. However, "lspci" utility provides correct information. I am not sure if this has anything to do with the number of DDR memory channels the motherboard has or why that would be a problem for PCI express device. However, this seem to be the common link between the machines that demonstrate this issue.

Could some one please let me know if you have ever experience this kind of problem before and/or any ideas to fix this problem?

Thank you very much,

Regards,

Sanka



      Need a Holiday? Win a $10,000 Holiday of your choice. Enter now.http://us.lrd.yahoo.com/_ylc=X3oDMTJxN2x2ZmNpBF9zAzIwMjM2MTY2MTMEdG1fZG1lY2gDVGV4dCBMaW5rBHRtX2xuawNVMTEwMzk3NwR0bV9uZXQDWWFob28hBHRtX3BvcwN0YWdsaW5lBHRtX3BwdHkDYXVueg--/SIG=14600t3ni/**http%3A//au.rd.yahoo.com/mail/tagline/creativeholidays/*http%3A//au.docs.yahoo.com/homepageset/%3Fp1=other%26p2=au%26p3=mailtagline
