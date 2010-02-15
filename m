Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0BOP6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:58:12 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:28586 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab0BOP6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:58:10 -0500
Date: Mon, 15 Feb 2010 10:56:53 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [LOCKING] 2.6.33-rc8 btrfs vs java
Message-ID: <20100215155653.GC11057@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ed Tomlinson <edt@aei.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <201002141914.50955.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002141914.50955.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B796F02.0170:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 07:14:50PM -0500, Ed Tomlinson wrote:
> Hi,
> 
> Found this in my log for 2.6.33-rc8.  Figgured it might be interesting since .33 is close.

The btrfs tree locking is very tricky for lockdep.  I don't quite see
how you could hit this one without also deadlocking the machine, unless
it is a false positive.

So, did you deadlock the machine? ;)

-chris
