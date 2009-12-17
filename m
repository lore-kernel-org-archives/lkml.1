Return-Path: <linux-kernel-owner+w=401wt.eu-S934692AbZLQR5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692AbZLQR5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765251AbZLQR5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:57:50 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:53564 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765234AbZLQR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:57:49 -0500
Date: Thu, 17 Dec 2009 09:57:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 17 (media/dvb)
Message-Id: <20091217095725.d7109149.randy.dunlap@oracle.com>
In-Reply-To: <20091217165840.e11fc719.sfr@canb.auug.org.au>
References: <20091217165840.e11fc719.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B2A7117.0062:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 16:58:40 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091216:


(repeating:)

drivers/media/dvb/frontends/dib8000.h:104: error: expected expression before '}' token
drivers/media/dvb/frontends/dib8000.h:104: warning: left-hand operand of comma expression has no effect

    return CT_SHUTDOWN,


s/,/;/ and fix indentation.

---
~Randy
