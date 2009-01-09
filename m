Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZAIXby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZAIXby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZAIXbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:31:40 -0500
Received: from mx.hosting-seguridad.com ([88.198.93.158]:34519 "EHLO
	mx.hosting-seguridad.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZAIXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:31:39 -0500
X-Spam-Score: -0.785
Message-ID: <4967DE52.3040709@rs-labs.com>
Date: Sat, 10 Jan 2009 00:31:30 +0100
From: Roman Medina-Heigl Hernandez <roman@rs-labs.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; es-ES; rv:1.8.1.19) Gecko/20081209 Thunderbird/2.0.0.19 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek
 driver
References: <49671B77.7080705@rs-labs.com> <200901092252.46448.elendil@planet.nl>
In-Reply-To: <200901092252.46448.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Frans Pop escribió:
> Roman Medina-Heigl Hernandez wrote:
>> It includes two RTL8111/8168B NICs, which seem the cause of the kernel
>> crashes (*but I'm not sure*)..., a Quad core, 4GB RAM and two 500GB HDs.
>>
>> I installed Debian Linux (4.0) on it and I'm getting *kernel panic*
>> errors (r8168 module) when set to production state. I couldn't get any
>> kernel debug messages since I'm using Debian stock kernel
>> (2.6.18-6-686-bigmem) and I'm not a kernel hacker either.
> 
> Have you tried the 2.6.24 kernel that is available for Debian Etch? That 
> seems to me the most logical thing to try first as a possible solution.

I didn't (although I thought of it). It seems to me like a blind attempt
and the problem is that I cannot afford to waste another "production
attempt" and that I cannot reproduce the crash whenever I want, so if I
upgrade I'll not be able to know whether the problem is fixed or not until
I got a new crash (or not). Moreover, if the root cause of the problem is
r8168 driver, it will crash in both cases (the driver doesn't change, it's
compiled from source by me).

Anyway, it's a good idea, I'll see if I have a new changes' window. Thank you.

-- 

Saludos,
-Roman

PGP Fingerprint:
09BB EFCD 21ED 4E79 25FB  29E1 E47F 8A7D EAD5 6742
[Key ID: 0xEAD56742. Available at KeyServ]
