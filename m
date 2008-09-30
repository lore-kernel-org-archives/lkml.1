Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYI3JiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYI3JiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYI3Jh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:37:58 -0400
Received: from web30102.mail.mud.yahoo.com ([209.191.69.34]:26009 "HELO
	web30102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752071AbYI3Jh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:37:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=lWktlmcsz/bRC+1PYrdN5ng6h0ZmNsgRQf7nCkm4ra3ew7oKif5h8jYjTescOID7Ztaf1aQN/aprXgsBLDk/7zSKmHKJ/YfL4QMChXO95ANC+ue54yxp7leJxhVO4fjvPG2ivEju5DIVby1fUmQ65NBItuw9tvK9CswVZd5EazI=;
X-YMail-OSG: .vz12PYVM1lShSSjz39X65jJ0uu9BsTMJmrq4qkhK4MKe.lESjSTfqCc5tinrArs5U9oxW_lyat62fGBH.BrQChUFT3z83b9x3d494TLiCEgDASr.cxykXQDaBbOJNzSOBb5vnWdHvr8FI2GxWtLS4Tw6yxXX9IKjZgBTPMTXU90NchJ4g--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 30 Sep 2008 02:37:57 -0700 (PDT)
From: Parav Pandit <paravpandit@yahoo.com>
Reply-To: paravpandit@yahoo.com
Subject: Re: Calculating time in order of 0.1usec on x86 system
To: Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <855204.33912.qm@web30108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <215667.93774.qm@web30102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting my desired numbers.
get_cycles()/cpu_khz gives the right time interval on x86 system.

Parav



--- On Tue, 9/30/08, Parav Pandit <paravpandit@yahoo.com> wrote:

> From: Parav Pandit <paravpandit@yahoo.com>
> Subject: Calculating time in order of 0.1usec on x86 system
> To: "Linux kernel" <linux-kernel@vger.kernel.org>
> Date: Tuesday, September 30, 2008, 12:31 PM
> Hi,
> 
> I need to calculate time spent by a function in order of
> less then a microsecond on x86 SMP platform.
> 
> Current profiling tools and gettimeofday() are not
> sufficient.
> 
> So I am using get_cycles() to get the CPU cycles.
> 
> Now how do I convert it into the time interval?
> 
> Do I have to divide it by "cpu_khz" variable? Or
> some other method?
> Is yes, what will be the unit of the result (time
> interval)? nsec/usec/msec?
> 
> e.g. get_cycles()/cpu_khz (unit?)
> 
> Or Is there more simpler method exist?
> 
> Regards,
> Parav Pandit
> 
> 
>       
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      
