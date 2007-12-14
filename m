Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbXLNQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbXLNQQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXLNQQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:16:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:63973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbXLNQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:16:05 -0500
Message-ID: <4762AC35.3010706@anagramm.de>
Date: Fri, 14 Dec 2007 17:15:49 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Siva Prasad <sprasad@bivio.net>, linux-kernel@vger.kernel.org
Subject: Re: printf internals
References: <D83235F0F3C86D4D889D8B9A0DA8C6D7011A8217@corpexc01.corp.networkrobots.com> <4761E289.9070007@davidnewall.com>
In-Reply-To: <4761E289.9070007@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX190G4uJWQ87oFSf/MMtF29jrfkkdSu4MIwfZZU
 1Uj0lUux7fCA8Fo1vRpCqfeaxgmzoAI4uf/EqrACKi5dVjZyr3
 pEQgGnAEWWtHq1hW09z9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall schrieb:
 > Siva Prasad wrote:
 >> I am looking at how exactly does the printf in user programs succeeds in
 >> displaying characters to the serial console.
 >
 > Is it a student assignment?  This is so not the right mailing list.

Come on, are we playing hide and seek here?

You can use strace to follow a typical hello world example and
see what device it opens to feed the hello out.
I.e. it can be to the current /dev/ttyX and not to /dev/console
or if you are logged in via SSH to a machine, the device
is again different... or if you use screen, ...

Work your way from there and then use a Linux Source code
Cross Reference (lxr, ask Google for one) and follow the code.

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

