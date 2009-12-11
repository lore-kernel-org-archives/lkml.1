Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZLKRhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZLKRhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZLKRg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:36:57 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:39469 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZLKRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:36:56 -0500
Date: Fri, 11 Dec 2009 09:36:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 11 (media/dvb/frontends)
Message-Id: <20091211093637.be0b6584.randy.dunlap@oracle.com>
In-Reply-To: <20091211160151.6b71078e.sfr@canb.auug.org.au>
References: <20091211160151.6b71078e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4B22833B.002A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 16:01:51 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091210:


drivers/media/dvb/frontends/dib0090.h:103: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'frontend_tune_state'

static inline num frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe)

s/num/enum/

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

drivers/media/dvb/frontends/dib8000.h:104: error: expected expression before '}' token
drivers/media/dvb/frontends/dib8000.h:104: warning: left-hand operand of comma expression has no effect

    return CT_SHUTDOWN,

s/,/;/
and use tab to indent.



someone built/tested these??

---
~Randy
