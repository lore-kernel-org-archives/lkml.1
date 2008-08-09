Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYHIEYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYHIEYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 00:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbYHIEYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 00:24:05 -0400
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:64730 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYHIEYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 00:24:04 -0400
References: <20080808195743.7EDAEB88F@nebuchadnezzar.smejdil.cz>
            <489CB25B.9040801@zytor.com>
In-Reply-To: <489CB25B.9040801@zytor.com>
From: "CIJOML" <cijoml@volny.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: PATCH: enable PAT at Pentium M 1.7 GHz
Date: Sat, 09 Aug 2008 06:24:00 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <20080809042401.0A7B4B8AE@nebuchadnezzar.smejdil.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes: 

> CIJOML wrote:
>> Hi there,
>> Sending oneliner enabling PAT at my Pentium M 1.7 GHz CPU. It simply 
>> works.
> 
> That's not really the right way to do that.  Unfortunately the likely 
> failure scenario is "data corruption after a month of uptime."  Thus, we 
> really need someone to review the relevant errata; I believe Venki is 
> planning to do so. 
> 
> 	-hpa

Well the truth is, that I use this little tweak from 2.6.26-rc and first cpu 
having PAT was P3 XEON. And because Intel has backward compatibility, it is 
safe to use it.
I don't have any problem with loosing data or any suspend/resume problems 
with this. 

Reference:
http://safari.ibmpressbooks.com/032124656X/ch32 

Best regards 

Michal
