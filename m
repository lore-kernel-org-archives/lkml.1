Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYINLdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYINLdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYINLdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:33:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46302 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbYINLdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:33:24 -0400
X-Sasl-enc: 9e+KOk9g5CWAeNyWpg+56GmzclH0IpomV/wYXesZcGMQ 1221392001
Date: Sun, 14 Sep 2008 08:33:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Helge Deller <deller@gmx.de>,
       linux-input@vger.kernel.org
Subject: Re: __initdata and struct dmi_system_id?
Message-ID: <20080914113316.GA27289@khazad-dum.debian.net>
References: <48C0C786.5020809@freemail.hu> <48CCBD83.1030001@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48CCBD83.1030001@freemail.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008, Németh Márton wrote:
> The other interesting question on this topic is that what about the
> error message strings which are used as parameter of the printk() calls.
> Those strings are combined together for a function which is marked with
> __init and the functions which are normal functions. The strings which
> are only used by the functions marked with __init could be freed, but
> the strings of the normal functions shouldn't be.

Yeah, if we could get them all in a init.rodata section, we could just throw
them away along with the init section afterwards...

I do think I have seen a patch about init.rodata in LKML not too long ago,
though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
