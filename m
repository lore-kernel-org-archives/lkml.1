Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0BFHY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 02:24:26 -0500
Received: from smtp118.rog.mail.re2.yahoo.com ([68.142.225.234]:22366 "HELO
	smtp118.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752247Ab0BFHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 02:24:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=E90IBENb2KmSqtZenikTeUhIWGNjozYt5eLGGYOaOfjdoLrF8gGFkW3j9W1bneDGf0M0tMSgCs/BhdI+GDrginn0o6pdOu0UK1EEJVLG7hQwN33HAkx4SneFbPHv3Jb7mengeEEVkWPSieE2NU956Udk4XFf7UcleoGZUMrnIeI=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 135IoXYVM1muSMKGg_5xgZ4CRM8tq56Pk7dG6L1e6MsZVPt6ePg4Lwnvu0biX6el7A--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: linux-kernel@vger.kernel.org
Subject: [2.6.33-rc6 fc76be4 w/ drm-radon-testing and KMS enabled] Weird JCPU times?
Date: Sat, 6 Feb 2010 02:24:20 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc6-custom-00237-g9b03279; KDE/4.4.61; x86_64; svn-1073382; 2010-01-11)
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002060224.20643.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running 2.6.33-rc6, I just happened to run w and saw this, while using 
radeon KMS, a subsequent restart, shows normal JCPU times.

 02:19:01 up  2:09,  3 users,  load average: 0.69, 0.67, 0.62
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
root     tty2                      02:12    6:41  213503days  0.00s -bash
spstarr  :0                        00:10   ?xdm?  6405119days 213503days 
/bin/sh /usr/local/kde4/bin/startkde
spstarr  pts/0    :0               00:10    2:08m  0.00s 213503days 
/usr/local/kde4/bin/kwrited

That certainly does not look right. I am running 2.6.33-rc6 git revision 
fc76be4 + drm-radeon-testing from airlied's git tree.

Anyone else notice this?

Thanks, 
Shawn.
