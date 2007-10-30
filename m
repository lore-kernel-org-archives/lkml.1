Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXJ3TyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXJ3TyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbXJ3TyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:54:10 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:45979 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbXJ3TyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:54:09 -0400
Message-ID: <47278BE8.6010901@oracle.com>
Date: Tue, 30 Oct 2007 12:54:16 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: checkpatch bug: space between left parenthesis and asterisk
References: <47278591.90305@freescale.com>
In-Reply-To: <47278591.90305@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> I'm running checkpatch.pl (dated 10/17), and it complains about this line:
> 
> crc = __be32_to_cpu(* ((__be32 *) ((void *) firmware + calc_size)));

Well, that is a bit of a stinker.  Maybe it could be reworked a little
to make it easier for humans and checkpatch to understand?

  __be32 *crazy_pointer = (void *)firmware + calc_size;
  crc = be32_to_cpu(*crazy_pointer);

(Does this need to worry about get_unaligned() at all?)

- z
