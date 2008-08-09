Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbYHIEeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbYHIEeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 00:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbYHIEeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 00:34:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43237 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYHIEeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 00:34:05 -0400
Message-ID: <489D1E28.3020004@zytor.com>
Date: Fri, 08 Aug 2008 21:33:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: CIJOML <cijoml@volny.cz>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: PATCH: enable PAT at Pentium M 1.7 GHz
References: <20080808195743.7EDAEB88F@nebuchadnezzar.smejdil.cz>            <489CB25B.9040801@zytor.com> <20080809042401.0A7B4B8AE@nebuchadnezzar.smejdil.cz>
In-Reply-To: <20080809042401.0A7B4B8AE@nebuchadnezzar.smejdil.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CIJOML wrote:
> 
> Well the truth is, that I use this little tweak from 2.6.26-rc and first 
> cpu having PAT was P3 XEON. And because Intel has backward 
> compatibility, it is safe to use it.
> I don't have any problem with loosing data or any suspend/resume 
> problems with this.

Sorry, it doesn't work that simple.  There are lots of errata in CPUs, 
and data loss is too critical.

You're of course welcome to run whatever you want on your machine, but 
we have to be more careful.

	-hpa
