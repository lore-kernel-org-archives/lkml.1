Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYCTUS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYCTUS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYCTUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:18:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57816 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYCTUSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:18:47 -0400
Date: Thu, 20 Mar 2008 13:16:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does "make oldconfig" always set CONFIG_SLUB_DEBUG=y ?
Message-Id: <20080320131602.a869bdaf.randy.dunlap@oracle.com>
In-Reply-To: <200803202035.41465.toralf.foerster@gmx.de>
References: <200803202035.41465.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 20:35:41 +0100 Toralf Förster wrote:

> I'm wondering why this option is always set after "make oldconfig" :
> 
> tfoerste@n22 ~/devel/linux-2.6 $ grep _SLUB_DEBUG=y .config
> CONFIG_SLUB_DEBUG=y
> tfoerste@n22 ~/devel/linux-2.6 $ sed -i -e 's/_SLUB_DEBUG=y/_SLUB_DEBUG=n/' .config
> tfoerste@n22 ~/devel/linux-2.6 $ grep _SLUB_DEBUG= .config
> CONFIG_SLUB_DEBUG=n
> tfoerste@n22 ~/devel/linux-2.6 $ make oldconfig 1>/dev/null
> tfoerste@n22 ~/devel/linux-2.6 $ grep _SLUB_DEBUG= .config
> CONFIG_SLUB_DEBUG=y
> 
> I attached the .config

Because it defaults to y and you can't change it unless you
enable EMBEDDED.

---
~Randy
