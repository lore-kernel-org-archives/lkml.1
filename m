Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYCTUTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYCTUTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYCTUTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:19:44 -0400
Received: from testure.choralone.org ([194.9.77.134]:43195 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYCTUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:19:44 -0400
Date: Thu, 20 Mar 2008 16:19:35 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does "make oldconfig" always set CONFIG_SLUB_DEBUG=y ?
Message-ID: <20080320201935.GC1328@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-kernel@vger.kernel.org
References: <200803202035.41465.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803202035.41465.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 08:35:41PM +0100, Toralf Förster wrote:
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

CONFIG_SLUB_DEBUG is only optional if CONFIG_EMBEDDED is set.
There's little to no cost other than codesize to having it enabled.

	Dave
 
-- 
http://www.codemonkey.org.uk
