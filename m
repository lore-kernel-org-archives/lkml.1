Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbXEKOVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbXEKOVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbXEKOVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:21:15 -0400
Received: from svr68.ehostpros.com ([67.15.48.48]:40947 "EHLO
	svr68.ehostpros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXEKOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:21:14 -0400
Subject: Re: statistics of filesystem-journal usage
From: Kalpak Shah <kalpak@linsyssoft.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070511140004.GD6261@vanheusden.com>
References: <20070511140004.GD6261@vanheusden.com>
Content-Type: text/plain
Date: Fri, 11 May 2007 19:54:26 +0530
Message-Id: <1178893466.6016.5.camel@garfield>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - svr68.ehostpros.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - linsyssoft.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 16:00 +0200, Folkert van Heusden wrote:
> Hi,
> 
> Maybe it is a nice idea to export statistics on the usage of a journal
> of a filesystem as well. That way one can more easy see if it would help
> to put a journal on an other harddisk.

There is a patch posted on linux-ext4 which maintains the journal
statistics such as transaction sizes and their lifetimes. These stats
are provided through procfs and can only be used with ext4 since ext2/3
still use the jbd layer.

You can see the patch here:
http://lists.openwall.net/linux-ext4/2007/04/02/6

- Kalpak.
> 
> 
> Folkert van Heusden
> 

