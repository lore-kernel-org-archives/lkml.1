Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYHBSQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYHBSQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbYHBSQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:16:38 -0400
Received: from web52907.mail.re2.yahoo.com ([206.190.49.17]:32363 "HELO
	web52907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758627AbYHBSQh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:16:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=yJ7hh5pA0IVK6kcWMpILL5km9VfaaHDbVNT7PTuN2wc7wWmAiSEp4dVNHQ0LZuNdbH/pY1jAlyj3rwtv56uUeEdDQH4bR12NXsNXFwhuF6d0Nd50piZCj1y2yRKODdxy/XalMPLw3LLT96l1QqtYnbLZPitYjlTInNTTEMwja9k=;
X-Mailer: YahooMailWebService/0.7.218
Date: Sat, 2 Aug 2008 11:16:35 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: Enabling PAT in 2.6.26.x
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <143234.6160.qm@web52907.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see that the PAT support in 2.6.26.x depends on the CPUID information, and that it is currently disabled for some older model Pentium IIIs:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 7
model name	: Pentium III (Katmai)
stepping	: 3
cpu MHz		: 498.862
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips	: 998.80
clflush size	: 32

I suppose that I could hack the kernel to allow PAT to be enabled for this model CPU, but I'm not sure how meaningful the results would be. Does PAT support either work immediately or not at all? Or are any errors likely to be more subtle?

Basically, is there any reliable way of confirming whether PAT can be enabled for the CPU, please?

Thanks,
Chris



      __________________________________________________________
Not happy with your email address?.
Get the one you really want - millions of new email addresses available now at Yahoo! http://uk.docs.yahoo.com/ymail/new.html
