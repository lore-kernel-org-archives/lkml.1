Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYCCMvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYCCMvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYCCMue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:50:34 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:49503 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYCCMuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:50:24 -0500
Date: Mon, 3 Mar 2008 09:50:15 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: serge@hallyn.com
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Mike Galbraith <efault@gmx.de>, buraphalinuxserver@gmail.com,
       elendil@planet.nl, stable@kernel.org
Subject: Re: [PATCH 1/1] file capabilities: remove cap_task_kill()
Message-ID: <20080303095015.6725686f@mandriva.com.br>
In-Reply-To: <20080229212634.GA7278@vino.hallyn.com>
References: <20080228173817.GA32661@vino.hallyn.com>
	<20080229174007.0a934cc6@mandriva.com.br>
	<20080229212634.GA7278@vino.hallyn.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 29 Feb 2008 15:26:34 -0600
serge@hallyn.com escreveu:

| Quoting Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br):
| > Em Thu, 28 Feb 2008 11:38:17 -0600
| > serge@hallyn.com escreveu:
| > 
| > | The original justification for cap_task_kill() was as follows:
| > | 
| > | 	check_kill_permission() does appropriate uid equivalence checks.
| > | 	However with file capabilities it becomes possible for an
| > | 	unprivileged user to execute a file with file capabilities
| > | 	resulting in a more privileged task with the same uid.
| > | 
| > | However now that cap_task_kill() always returns 0 (permission
| > | granted) when p->uid==current->uid, the whole hook is worthless,
| > | and only likely to create more subtle problems in the corner cases
| > | where it might still be called but return -EPERM.  Those cases
| > | are basically when uids are different but euid/suid is equivalent
| > | as per the check in check_kill_permission().
| > | 
| > | This patch removes cap_task_kill().
| > 
| >  2.6.24 seems to have the same bug, what about a rediff for it and
| > submit the patch to -stable team?
| 
| Luiz, could you confirm that the below works?

 Yes, it does.

 Thanks.

-- 
Luiz Fernando N. Capitulino
