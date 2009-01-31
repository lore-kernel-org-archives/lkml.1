Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZAaHBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZAaHBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 02:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZAaHBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 02:01:37 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33292 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbZAaHBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 02:01:36 -0500
To: linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, Alex Chiang <achiang@hp.com>, djwong@us.ibm.com,
       Trent Piepho <xyzzy@speakeasy.org>, <linux-kernel@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 30 Jan 2009 23:01:43 -0800
Message-ID: <m1fxj06js8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, xyzzy@speakeasy.org, djwong@us.ibm.com, achiang@hp.com, jbarnes@virtuousgeek.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;linux-pci@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Q: state of pci express hotplug
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trying to use the current pciehp code, on real hardware in an 
interesting topology (more later) I'm not finding it very satisfactory
at all.  I am up to at least three show stopper bugs and the code
is not doing what I really need it to do, so I am looking at a significant
rewrite patch effort to make this code usable.

Am I unique in thinking there is a lot that needs to be done?
Is there current work in progress to make the pci hotplug work better?

I would like to avoid duplicate work if I can.

Eric

