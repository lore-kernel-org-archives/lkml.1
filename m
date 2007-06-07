Return-Path: <linux-kernel-owner+w=401wt.eu-S937774AbXFGWcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937774AbXFGWcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937404AbXFGWcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:32:08 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:37177 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S937204AbXFGWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:32:06 -0400
X-YMail-OSG: FonEErwVM1kSc30KInG50D5ND_PMA4o_QHD8bnbxiqww80KuwTtR_y_Egdwa.EoicFwt4WjCfQ--
X-RocketYMMF: rancidfat
Date: Thu, 7 Jun 2007 15:32:04 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Audit: Add TTY input auditing
To: Jan Engelhardt <jengelh@computergmbh.de>, Miloslav Trmac <mitr@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Alexander Viro <aviro@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0706072305380.1370@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <713627.48330.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:


> Someone please enlighten me why a regular keylogger² that captures
> both input and output could not do the same. (Auditing what one has done.)

1. shell aliases
   # innocuous -p 0 
2. shell variables
   # $INNOCUOUS -p 0
3. symlinks
   # ./innocuous -p 0

Yes, I know there are ways to prevent each of these "attacks",
but it's surprising how often simple textual changes are effective
in hiding behavior.


Casey Schaufler
casey@schaufler-ca.com
