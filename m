Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbYHHUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbYHHUyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYHHUyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:54:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYHHUyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:54:13 -0400
Message-ID: <489CB25B.9040801@zytor.com>
Date: Fri, 08 Aug 2008 13:53:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: CIJOML <cijoml@volny.cz>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: PATCH: enable PAT at Pentium M 1.7 GHz
References: <20080808195743.7EDAEB88F@nebuchadnezzar.smejdil.cz>
In-Reply-To: <20080808195743.7EDAEB88F@nebuchadnezzar.smejdil.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CIJOML wrote:
> Hi there,
> Sending oneliner enabling PAT at my Pentium M 1.7 GHz CPU. It simply works.

That's not really the right way to do that.  Unfortunately the likely 
failure scenario is "data corruption after a month of uptime."  Thus, we 
really need someone to review the relevant errata; I believe Venki is 
planning to do so.

	-hpa
