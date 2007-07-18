Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXGRNwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXGRNwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXGRNwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:52:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:10693 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbXGRNwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=UtI4bSKm2RBNW5I3VSkDHxFifj7PLAai9fvim72FbSNlbKoVkFJaUft16XpYH4zBmxNN4f5DXlS9CnRsbDBx70U5bLl66HZKScS8dAMlDfFGjGodRoIYN01U4CvAPbZ5P7WyXam4hu33yIzK0vfU/mXYptGN3A87/VIdfAEejOQ=
Message-ID: <469E1AFE.7010108@gmail.com>
Date: Wed, 18 Jul 2007 09:51:58 -0400
From: Parag Warudkar <parag.warudkar@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22 - Suspend and Weird Load Averages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For the first time since 1997 I have a machine (Mac Mini) running a 
stock kernel which I am suspending/resuming for 2 days now without any 
problems. Amongst the various hardware and kernel versions that I've 
used so far this combination is the first to suspend/resume without issues!

But one thing that annoys me a bit is that the load averages spike up 
quite a bit after resume although it doesn't feel like the machine is 
loaded  -

Before Resume -
parag@parag-desktop:~$ uptime
 09:35:14 up  5:18,  2 users,  load average: 0.08, 0.87, 1.00
After Resume -
parag@parag-desktop:~$ uptime
 09:36:37 up  5:18,  2 users,  load average: 12.53, 3.83, 1.98
parag@parag-desktop:~$

Is this a known problem? Worth fixing?

Thanks
Parag
