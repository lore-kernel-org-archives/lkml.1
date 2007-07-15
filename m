Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbXGOSo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbXGOSo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 14:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXGOSou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 14:44:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:60125 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXGOSot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 14:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=ts6TwA7d2jFF/rXm01C+iDTeppRcQaSM1wnjW1TySIyegTZ1PSQ04Jv+sFqHUOp43Ti1B3XeMtZFAw0mIBc7lynKXWUY4P2sNeN1SfKKlTWhpwFR9GGtX0PUHd3PwOVqErydMitx5oZLI9yo0WpBfKSDK66AO9tGGp3wC+IxR4I=
Message-ID: <469A6B1A.2040908@gmail.com>
Date: Mon, 16 Jul 2007 00:14:42 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: TripleX Chung <triplex@zh-kernel.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Ask for help, about the trivial patches.
References: <4697C980.1040902@zh-kernel.org> <9a8748490707131354y37793f0ag2c01b2bdf968f8cc@mail.gmail.com> <469A4B9B.4040008@zh-kernel.org>
In-Reply-To: <469A4B9B.4040008@zh-kernel.org>
X-Enigmail-Version: 0.95.2
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TripleX Chung wrote:
> Jesper Juhl wrote:
>> Note: my explanations below are based on how I understand these
>> things, but I'm not the trivial patch monkey nor did I help create
>> these guidelines, so I'm in no way authoritative on the subject.
>>
>> On 13/07/07, TripleX Chung <triplex@zh-kernel.org> wrote:
>>> I am working on the chinese translated version of
>>> Documentation/SubmittingPatches and get some problem about the "Trivial
>>> patches".I can not understand what "Trivial patches" exactly means.The
>>> documentation said:
>>>
>> If you are unclear of the meaning of the word "trivial", then take a
>> look here for an explanation: http://www.m-w.com/dictionary/trivial
>>
> Thanks for your help. 
> But I still have problems.
> Trivial means "of little worth or importance". But some of the examples
> in the rules are important, like "runtime fixes". Spell fixes must be
> unimportant, but most of the runtime fixes like memory leaks or NULL
> pointers must be important. I was still a little confused with them.
> 

Literally, yes. But look at it from a s/w engineering point of view.

A NULL pointer deref is important, but it is also a *very local* and
very obvious fix (one that doesn't need extensive testing, one that
doesn't have effects spread out over many modules that requires great
amount of thought).

So such things are trivial bug-fixes.

-jb
-- 
Tact is the art of making a point without making an enemy.
