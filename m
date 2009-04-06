Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbZDFPg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbZDFPg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZDFPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:34:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51767 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZDFPes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:34:48 -0400
Subject: Re: [PATCH 0/2] security/smack implement logging V2
From: Eric Paris <eparis@redhat.com>
To: Etienne Basset <etienne.basset@numericable.fr>
Cc: LSM <linux-security-module@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-audit@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sgrubb@redhat.com, sds@tycho.nsa.gov
In-Reply-To: <49D86FFA.1010507@numericable.fr>
References: <49D86FFA.1010507@numericable.fr>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 11:34:26 -0400
Message-Id: <1239032066.4009.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 10:46 +0200, Etienne Basset wrote:

> the following 2 patches implements auditing of security events for Smack.
> It tries to implement what Eric Paris suggested, and moves shareable code
> to include/linux/lsm_audit.h and security/lsm_audit.c.
> Smack specific logging functions are now defined in smack_access.c


> type=1400 audit(1238919813.116:21): SMACK[smack_inode_getattr]: action=denied subject="FOO" object="etienne" requested=r pid=6679 comm="bash" path="/home/etienne/Desktop" dev=sda8ino=1237000

Can we make SMACK[smack_inode_getarr] into key=value pairs too and get
rid of that extra ':'?  Anyone have naming suggestions?

lsm=SMACK function=smack_inode_getattr

also: dev=sda8ino=1237000  I'm guessing that was just a typo of you
putting the example into the e-mail, but you may want to double check.

-Eric

