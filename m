Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbXFORyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbXFORyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXFORyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:54:39 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:44642 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXFORyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:54:38 -0400
Message-ID: <4672D246.2040306@nortel.com>
Date: Fri, 15 Jun 2007 11:54:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       dave young <hidave.darkstar@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: coding style
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg>
In-Reply-To: <20070615173206.GA8151@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 17:54:18.0350 (UTC) FILETIME=[320468E0:01C7AF76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:

> Thanks to all of you for answering. Actually I was concerning about function
> arguments' alignment (on separated lines) not about indentation. So as I see
> it's a question of bent ;) And a simple rule exist - use tabs for indents
> and spaces for alignment (when amount of spaces are < 8).

That rule doesn't actually work though, an is imposed by tools limitations.

Consider two people, one with tabs as 8 characters and one with tabs as 
4 characters.  If person A aligns using a tab plus a space (giving 9 
characters), then the alignmnet will be all screwed up for person B (who 
will see 5 characters of alignment).

The only rule that works (setting aside bad tools) is:

"use tabs for indents and spaces for alignment"

If that means you need to use two dozen spaces, then so be it.

Chris
