Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZIISEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZIISEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZIISET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:04:19 -0400
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91]:24069 "HELO
	n6.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753642AbZIISES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:04:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 998615.54237.bm@omp104.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=oUaN85KhB1srSXaJsPHEvRy8edioxrKuH+xmRtpIOW6967Dag7wAMcaJm7/AQbI3zQ95FqYh5tpBkncljBkIN4+84ijYR4+1UX+ayx15eNC4zE9gm08IWN3thnn44RZjKSAbi6peOnGs0PRin5SFRvFjaz3pLFGu1hTYWkqEjSE=;
Message-ID: <806810.23677.qm@web59313.mail.re1.yahoo.com>
X-YMail-OSG: 1FPls9kVM1kYi8tlXGDl1kfAMGLBRW8St7FH6ggPIA6.2VCiGehhWXiSsgMWEyUoXaSzLxARYhpbcsWKXvcfNS8x_txNuBzEqgXZH8rZrrScKluLe6teY3HGJeG_1JXPMsFbMSEhk7eDXaKwAdNR7p.XGxyQg0y952ljnmdXg_jPzbN2CQNP1m4bdGIlmrMR3pZqRm.MEA2OwVJQ5_uBJdlbmjDg1tU_RyV2yd8tvc3zK5IlKU6r0f6CWks7NQ_29WtGMXeQVi8akPY-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.347.2
Date: Wed, 9 Sep 2009 11:04:20 -0700 (PDT)
From: Dok Sander <doksander@yahoo.com>
Subject: io.h doesn't get installed by target "headers_install" for mips
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 I noticed the absence of the header io.h while trying to build(cross-compile, host i686-pc-linux-gnu) a software(lm-sensors-3.1.1, wants io.h in /sys) for mips. I can find io.h for mips in arch/mips/asm/include/{,sn/} However, io.h doesn't get installed when i do "make ARCH=mips headers_install" on linux 2.6.30.6

 According to someone on the eglibc mailing list, linux should provide io.h for mips. Is this true?

  Thank you,


      

