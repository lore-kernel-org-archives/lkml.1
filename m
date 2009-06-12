Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbZFLJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbZFLJL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbZFLJLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:11:19 -0400
Received: from main.gmane.org ([80.91.229.2]:45066 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760205AbZFLJLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:11:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core  temperature
Date: Fri, 12 Jun 2009 09:11:08 +0000 (UTC)
Message-ID: <loom.20090612T090524-359@post.gmane.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org> <loom.20090610T172830-164@post.gmane.org> <20090611153255.ba8d6c54.akpm@linux-foundation.org> <20090612101200.3fe6d494@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 193.2.6.240 (Opera/9.63 (Windows NT 5.1; U; en) Presto/2.1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali <at> linux-fr.org> writes:
>  
> > > On the other hand 
> > > cat '/sys/class/hwmon/hwmon2/device/driver/via-cputemp.0/temp1_input' 
outputs 
> > > numbers between 25-27. 
> > > 
> 
> Temperature values are supposed to be expressed in millidegrees C, not
> degrees C as it seems to be doing (although 25 degrees C seems pretty
> low for a CPU temperature?) The drivers needs to multiply values by
> 1000 before exporting them to sysfs. Then "sensors" will report the
> correct temperature value.
> 

It goes up to 48 degrees C when I run cpuburnP6. 

Tomaz Mertelj


