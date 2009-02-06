Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZBFXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZBFXfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZBFXf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:35:27 -0500
Received: from mx0.towertech.it ([213.215.222.73]:46852 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753087AbZBFXf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:35:26 -0500
Date: Sat, 7 Feb 2009 00:35:22 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] Soekris net5501 board support code
Message-ID: <20090207003522.32049f4f@i1501.lan.towertech.it>
In-Reply-To: <20090206152121.3ae5208a.akpm@linux-foundation.org>
References: <20090205161319.32219d93@i1501.lan.towertech.it>
	<20090206152121.3ae5208a.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 15:21:21 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	rombase = ioremap(0xffff0000, 0xffff);
> > +	if (!rombase)
> > +		return 0;  
> 
> Is it appropriate to silently "succeed" if the ioremap() failed?

 maybe not.. I'll add a printk. ty.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

