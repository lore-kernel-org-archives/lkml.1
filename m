Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbXKLSoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbXKLSoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759184AbXKLSn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:43:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbXKLSnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:43:55 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: AppArmor Security Goal
To: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Reply-To: 7eggert@gmx.de
Date: Mon, 12 Nov 2007 19:43:44 +0100
References: <9nngC-6iQ-25@gated-at.bofh.it> <9o6Qq-2Hk-17@gated-at.bofh.it> <9o6Qq-2Hk-15@gated-at.bofh.it> <9o706-2Xe-17@gated-at.bofh.it> <9o7jp-3lE-5@gated-at.bofh.it> <9o7Wg-4sT-15@gated-at.bofh.it> <9of7j-7ej-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1IreG9-00013R-0K@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+ZnZ0WGu6K2oxezzRWNZNGR5wbsKBEm7sjZWP
 TLOjINI7TrORHbK2P0btfTenYQAG2Mxppkrsl1EAh11GD5eNMt
 Aqe1yjatdOMtW0wbFRaPQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rogelio M. Serrano Jr. <rogelio@smsglobal.net> wrote:
> Dr. David Alan Gilbert wrote:

>> Allowing a user to tweak (under constraints) their settings might allow
>> them to do something like create two mozilla profiles which are isolated
>> from each other, so that the profile they use for general web surfing
>> is isolated from the one they use for online banking.
>>
>>   
> Doesnt this allow the user to shoot their own foot? The exact thing
> mandatory access control are supposed to prevent?

cat `which mozilla` > ~/bin/mymozilla; chmod +x ~/bin/mozilla; mymozilla

Unless you lock down the system to a state where it's barely usable, MAC
isn't going to protect you from shooting your own feet. But having more
restricted roles and a safe way of activating them (as in "damn obvious
if or if not this role is active"), you can have e.g. one mozilla for
banking and one for pr0n.

