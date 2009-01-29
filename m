Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZA2CGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZA2CGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZA2CGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:06:41 -0500
Received: from n4a.bullet.mail.ac4.yahoo.com ([76.13.13.67]:36493 "HELO
	n4a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752522AbZA2CGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:06:40 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 724564.82350.bm@omp109.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=T1YCFPiTZLlvFIUC23yX6JMe0sDvZgxh1qJTsUJoL0cjm4l08h0Yz7PIq3ksCjnytOjz0m5sQclAz8zLCJa1qtxnVWBvLAr4UlSx5WWw2XuztdbKuAw5JnfvSRypuY9zaalUH64Mh5mjOzWon4jkko18/2vfpde81QCQdV3eXgY=;
X-YMail-OSG: JCloMg4VM1nHzN3gW_nUQe.hrRaMGHoRQSdssmCsvBdcxguMOM_yIU01muADlMJ6DFxRcriwO2tCgL4eNSarjAFnqoUU_uO9BCd5JNHTaecGSHXu4vbMEBB5LNBWekyI4DB4jy3_N2JKiDecBEDKHm8yZSfXWx8tqpeDnfeSWAM.kPEpHbxIfe2YiT0SSY2NagfXuUc-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Wed, 28 Jan 2009 18:06:37 -0800 (PST)
From: Xiaoning Ding <dingxn@ymail.com>
Reply-To: dingxn@ymail.com
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090128210200.GA19527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <630240.73962.qm@web59913.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the correction. 
My experiments need to reduce CPU speed. However, I can only reduce the speed by about 30% (from 2.67GHz to 2GHz) with ACPI. That is not enough for the experiments. 

p4-clockmod has not been removed from 2.6.29. It is under the same directory as acpi-cpufreq (arch/x86/kernel/cpu/cpufreq). So I thought it was an alternative approach. But I could not get it loaded.

Xiaoning


--- On Wed, 1/28/09, Dave Jones <davej@redhat.com> wrote:

> From: Dave Jones <davej@redhat.com>
> Subject: Re: a question about p4_clockmod module on Xeon quad core processors
> To: "Xiaoning Ding" <dingxn@ymail.com>
> Cc: linux-kernel@vger.kernel.org
> Date: Wednesday, January 28, 2009, 9:02 PM
> On Tue, Jan 27, 2009 at 12:17:25PM -0800, Xiaoning Ding
> wrote:
>  > Hi list,
>  > 
>  > I have tried the p4-clockmod module in Linux kernel
> 2.6.29 on Xeon 5355 quad-core CPUs with no luck. It seems
> current p4-clockmod driver still cannot support Intel Quad
> core processors, right? 
>  > 
>  > I know I can also use acpi-cpufreq. It can only scale
> down the frequence from 2.67GHz to 2GHz. But I need some
> lower frequencies for some experiments.
> 
> p4-clockmod doesn't change the processor frequency.
> Because of common misconceptions like this, the user
> interface has been removed.
> 
> In 2.6.29, the clock modulation code is called directly
> from ACPI
> whenever thermal events indicate that throttling is
> necessary.
> 
> 	Dave
> 
> -- 
> http://www.codemonkey.org.uk


      

