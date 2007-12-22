Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbXLVUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbXLVUmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbXLVUmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:42:01 -0500
Received: from slackadelic.com ([65.196.224.53]:38047 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbXLVUmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:42:00 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: =?iso-8859-1?q?R=E9mi_H=E9rilier?= <rherilier@yahoo.fr>
Subject: Re: PATCH] adding wistron_btns support for X86_64 systems.
Date: Sat, 22 Dec 2007 20:40:13 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, dtor@mail.ru, linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200712222040.14422.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing linux-input, as that is the relevant subsystem list for wistron-btns).

Rémi Hérilier wrote:
> To use my previous patch (wistron_btns support for fujitsu-siemens amilo
> pro edition v3505) with my laptop, I need to make the wistron module
> compile for x86_64. It is based on Linux 2.4.24-rc4 too.

NAK.

You cannot make 32 bit BIOS calls in a 64 bit OS.

This will (and does) segfault on x86-64 (tested on my Aspire 5020, where  
call_bios wistron-btns just segfaults on x86-64 with this patch).

This is a known issue, and the reason why wistron-btns (and the out-of-tree 
acerhk) have not been ported to x86-64.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
