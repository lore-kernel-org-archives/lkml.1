Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZERIQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZERIQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZERIQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:16:00 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:26215 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751968AbZERIP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:15:59 -0400
Message-ID: <424718.52835.qm@web32607.mail.mud.yahoo.com>
X-YMail-OSG: oyBN2oIVM1l6V20EeXE53XjCtjSOBxDjKUmofFw7h_RoFN.Pf6DYML014s8.3PQbiM2MTNO3V6bPvLk6HH_dtzcUsShHYx2JdcLCtPUhbN1vm9mgyCO3JmvdTnSvP9sGgGFB41Vxj4kPJccMmiNdYYbKdj3C4gw_QeZpM4YXIQLFwmACUdrp40wciPMrKS9xQC6hqrAxukRJXumX4eTGPk0urCReEuovxFSPdySMM33Omnyaf3zR6fqcc5no5DfYmnhXwD_dtOAx5tmFbmHaC7Ncu.px25bc599vMSFaXeNI4lheD6rMmEbj0cFLqwkZ2hYOGXx7PFlg_gYFrMYwiw--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.scG.LA0DKB@chimera>
Date: Mon, 18 May 2009 01:15:59 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [Bug #13178] Booting very slow
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <pQ9WADCjgyE.A.scG.LA0DKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Rafael J. Wysocki <rjw@sisk.pl>
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: Kernel Testers List <kernel-testers@vger.kernel.org>; Martin Knoblauch <spamtrap@knobisoft.de>
> Sent: Saturday, May 16, 2009 10:06:02 PM
> Subject: [Bug #13178] Booting very slow
> 
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
> Subject        : Booting very slow
> Submitter    : Martin Knoblauch 
> Date        : 2009-04-24 12:45 (23 days old)
> References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4

 The issue is still open. It turns out that starting with 2.6.29-rc1 /proc/mounts already has a "sysfs" line when entering the startup scripts from initrd. This breaks the RHEL4 firmware hotplug script.

Simple fix to user space is available. I do not know how important this issue is.

Anyway, I am in the process of bisecting the problem. It is just a bit tedious in the my customers and employers environment :-(

Cheers
Martin

