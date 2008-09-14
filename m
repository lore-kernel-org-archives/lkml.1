Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYINQ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYINQ1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYINQ07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:26:59 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64012 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYINQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:26:58 -0400
Message-ID: <48CD3B4C.8010106@freemail.hu>
Date: Sun, 14 Sep 2008 18:26:52 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Helge Deller <deller@gmx.de>, Jan Beulich <jbeulich@novell.com>,
       linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: __initdata and struct dmi_system_id?
References: <48C0C786.5020809@freemail.hu> <48CCBD83.1030001@freemail.hu> <20080914113316.GA27289@khazad-dum.debian.net>
In-Reply-To: <20080914113316.GA27289@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32721; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Sun, 14 Sep 2008, Németh Márton wrote:
>> The other interesting question on this topic is that what about the
>> error message strings which are used as parameter of the printk() calls.
>> Those strings are combined together for a function which is marked with
>> __init and the functions which are normal functions. The strings which
>> are only used by the functions marked with __init could be freed, but
>> the strings of the normal functions shouldn't be.
> 
> Yeah, if we could get them all in a init.rodata section, we could just throw
> them away along with the init section afterwards...
> 
> I do think I have seen a patch about init.rodata in LKML not too long ago,
> though.

Do you mean this one?

Date: Fri, 05 Sep 2008 13:03:17 +0100
From: Jan Beulich <jbeulich@novell.com>
Subject: [PATCH] .init.rodata and modpost adjustments
http://lkml.org/lkml/2008/9/5/126

Regards,

	Márton Németh
