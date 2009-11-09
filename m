Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZKIPWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZKIPWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZKIPWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:22:03 -0500
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:32653 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753790AbZKIPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:22:02 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2009 10:22:02 EST
Message-ID: <799070.68490.qm@web32608.mail.mud.yahoo.com>
X-YMail-OSG: boWWM5EVM1m8Kl7Bx92UFzYQTTLPCEy1pbgviklwZr1k6Cx3_NJLdMMO_Tv68e65jPmhPwUm_Z32m_U7ZhOj7BWpW3riI9kuyKJb97zSaL6Dy0z6V4vlqcQqvoeHsbJy7bNV4Cdr.aVziAi4l1tWrtvZX9OEZp85iL4K2u0GR8dFO9rG2S18ZJ.9PP1bOYOxsIPti2ko7gvoX6JHUYi4vvea1fxxAPhvXmynPEtlP7yhOdeVKPWVF_COzwOiLln_F9veIVkwyq5ro3UQwI6Z1IJxlzKI5z6dJls2uQOKtTyrQXVFduehAVE0TxZQagbJEDw1boSYwnbpEmCc._9XRt1hnhKrINmHz3WdH.VMqSBsFN_WRIkO7DXEDnfO4MFwGmWCwbb.AQWIr8lcdt4bWqHaBUtaT9fwyn2wdYTUbbyavA_Hu3E-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/211.6 YahooMailWebService/0.7.361.4
Date: Mon, 9 Nov 2009 07:15:25 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Likley stupid question on "throttle_vm_writeout"
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, (please CC me on replies)

 I have a likely stupid question on the function "throttle_vm_writeout". Looking at the code I find:

                if (global_page_state(NR_UNSTABLE_NFS) +
                        global_page_state(NR_WRITEBACK) <= dirty_thresh)
                                break;
                congestion_wait(WRITE, HZ/10);

Shouldn't the NR_FILE_DIRTY pages be considered as well?

Cheers

Martin 
------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de

